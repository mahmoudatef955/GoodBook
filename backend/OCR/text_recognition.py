#################################################################################################################################
#add padding to the merged boxes to cover all the text area. -------------> very promising<--------------------
#
# image text detection <<<<<<< done
	#-using EAST 
# preprocessing the bounding boxes for recognition >>>>>>>> un-done(attempts failed )
	#possible methods:
		#we can discard small boxes to remove non-necessary words ---->promising ---->bad idea
		#we can merge the bounding boxes into larger ones this would remove duplicated or overlapping words --->very promising -----> done
		#add padding to the merged boxes to cover all the text area. -------------> very promising
		#we can use adaptive thresholidng and some filtering to clean the image ---> also promising
# image text recongnition <<<<<done
	#using pytesseract
# text preprocessing >>>>>>> done  
	#current procedures:
		#- removed punctuations from text 
		#- removed single characters and empty strings
		#- removed duplicates
		#- choose first 6 elements as our main candidates
	#possible procedures:
		#- removing meaningless words using a dictioanry ----> i guess it won't be very effective
		#- using a method to understand the context and remove un suitable words ----> dont know how yet
		#- using pattern matching to to handle OCR errors -----> dont know how yet
###################################################################################################################################
#
# 
# 
# run the program : python text_recognition.py --east frozen_east_text_detection.pb --image images/example_01.jpg
###################################################################################################################################
###################################################################################################################################

# import the necessary packages
from imutils.object_detection import non_max_suppression
import numpy as np
import pytesseract
import argparse
import cv2 as cv
from matplotlib import pyplot as plt
import string
from util import boundingBoxes, OrigBoxes,  decode_predictions

####################################################################################################################################
####################### parsing user input
ap = argparse.ArgumentParser()
ap.add_argument("-i", "--image", type=str,
	help="path to input image")
ap.add_argument("-east", "--east", type=str,
	help="path to input EAST text detector")
ap.add_argument("-c", "--min-confidence", type=float, default=0.9,
	help="minimum probability required to inspect a region")
ap.add_argument("-w", "--width", type=int, default=288,
	help="nearest multiple of 32 for resized width")
ap.add_argument("-e", "--height", type=int, default=288,
	help="nearest multiple of 32 for resized height")
ap.add_argument("-p", "--padding", type=float, default=0.095,
	help="amount of padding to add to each border of ROI")
args = vars(ap.parse_args())

####################################################################################################################################
##text detection using East 
#load image 
image = cv.imread(args["image"])
#copy the image 
orig = image.copy()
#apply east detector
boxes, rH, rW , origH, origW = boundingBoxes(image, args["width"], args["height"], args["east"], args["min_confidence"])
#################################################################################################################################
#################################################################################################################################
##applying pre-processing on the bounding boxes 
padding = args["padding"]
bboxes = OrigBoxes(boxes, rW, rH, origW, origH, padding)
###################################################
##### trying to merge the bounding boxes

init_results = bboxes.copy()
merged = []
# sort the bounding boxes from top to bottom
init_results = sorted(init_results, key=lambda r:r[0][1])
#loop over the bounding boxes list to and merge adjacent bounding boxes
for i, j in enumerate(init_results):
	if( i<len(init_results)-1 and ( (abs(init_results[i+1][0][1] - j[0][1]) < 120) or (abs(init_results[i+1][0][1] - j[0][3]) < 120) ) ): #text is almost on the same line
		A_X = min(j[0][0], init_results[i+1][0][0])              										#startX of the bigger box    		
		A_Y = min(init_results[i+1][0][1], j[0][1]) 					# StartY of the bigger box
		B_X = max(init_results[i+1][0][2], j[0][2])               					# endX of the bigger box
		B_Y = max(init_results[i+1][0][3], j[0][3])
		#roi = orig[A_Y:B_Y, A_X:B_X]
		#plt.imshow(roi)
		#plt.show()
		size_new = abs(B_Y-A_Y)*abs(B_X-A_X)
		init_results[i+1]=tuple(((A_X, A_Y, B_X, B_Y), size_new))
# sort bounding boxes according to size
init_results = sorted(init_results, key=lambda r:r[1])
init_results = init_results[len(init_results)-1:]

#################################################
#####applying East on Candidate box
(A_X, A_Y, B_X, B_Y), size_Max = init_results[0]
maxBox = orig[A_Y:B_Y, A_X:B_X]
maxBoxOrig = maxBox.copy()
#maxBoxBin = cv.cvtColor(maxBox, cv.COLOR_BGR2GRAY)
#apply bluring 
#maxBoxblur =  cv.GaussianBlur(maxBoxBin, (3,3), 0)
#apply thresholding
#_,ret3 = cv.threshold(maxBoxblur, 0 ,255 , cv.THRESH_BINARY+cv.THRESH_OTSU )
#maxBoxOtsu = ret3.copy()
#plt.imshow(maxBoxOtsu)
#plt.show()
#maxBoxBGR = np.stack((maxBoxOtsu,maxBoxOtsu,maxBoxOtsu),axis=-1)
maxboxes, MrH, MrW , MorigH, MorigW = boundingBoxes(maxBoxOrig, args["width"], args["height"], args["east"], args["min_confidence"])
maxboxesOrig = OrigBoxes(maxboxes,MrW,MrH,MorigW,MorigH, 0.05, 2)

###############################################################################################################################
###############################################################################################################################
####text recognition using tesseract	
#create a list of reuslts
results = []
#loop of the most suitable bounding boxes
for ((startX, startY, endX, endY),size) in maxboxesOrig:
	
	roi = maxBoxOrig[startY:endY, startX:endX]
	# in order to apply Tesseract v4 to OCR text we must supply
	# (1) a language, (2) an OEM flag of 4, indicating that the we
	# wish to use the LSTM neural net model for OCR, and finally
	# (3) an OEM value, in this case, 7 which implies that we are
	# treating the ROI as a single line of text
	config = ("-l eng --oem 1 --psm 7")
	text = pytesseract.image_to_string(roi, config=config)
	#text= "hello"

	# add the bounding box coordinates and OCR'd text to the list
	# of results
	results.append(((startX, startY, endX, endY), text))

##################################################################################################################################
##################################################################################################################################
### display the results

# sort the results bounding box coordinates from top to bottom left to right
results = sorted(results, key=lambda r:r[0][1])
#results = sorted(results, key=lambda r:r[0][0])

# loop over the results
output = maxBox.copy()
TEXT = []
for ((startX, startY, endX, endY), text) in results:
	words = text.split()
	TEXT.append(words)
	# strip out non-ASCII text so we can draw the text on the image
	# using OpenCV, then draw the text and a bounding box surrounding
	# the text region of the input image
	#text = "".join([c if ord(c) < 128 else "" for c in text]).strip()
	#output = orig.copy()
for ((startX, startY, endX, endY), size) in results:
	cv.rectangle(output, (startX, startY), (endX, endY),
		(0, 0, 255), 2)
	#cv.putText(output, text, (startX, startY - 20),
	#	cv.FONT_HERSHEY_SIMPLEX, 1.2, (0, 0, 255), 3)
###################################################################################################################################
###################################################################################################################################
##post processing --- text cleaning
#flatten the list
Text = [item for sublist in TEXT for item in sublist]
#remove punctuations 
sympols = '(){}.,-:;*/\|=<>$#\''
stripped = [item.translate(str.maketrans('','',sympols)).strip() for item in Text]
#remove single characters from the list
stripped = [i for i in stripped if len(i)>2 or i=='of' or i=='Of'or i=='OF' or i=='oF']
#remove duplications 
for i , j  in enumerate(stripped):
	if ( (i<len(stripped)-1) and ((j in stripped[i+1] ) or (stripped[i+1] in j))):
		if(len(stripped[i+1]) > len(j)):
			del stripped[i]
		else:
			del stripped[i+1]
#Take only 6 elements from the list# 
if(len(stripped)>6):
	stripped = stripped[:8]		
print(stripped)
####################################################################################################################################
####################################################################################################################################
# show the output image
plt.imshow(output)
plt.show()