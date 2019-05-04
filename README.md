# Book Title Recognition

## Pipeline

![img1](https://user-images.githubusercontent.com/26282714/57181327-8492bb00-6e92-11e9-927c-5a1951325ec7.png)

___

## Text detection

for text detection we used EAST (An efficient and accurate scene text detector)
![Figure_2](https://user-images.githubusercontent.com/26282714/57181426-cc661200-6e93-11e9-8fe0-c1233378045e.png)

___

## Image Processing

we simply merge the bounding boxes into a larger one
most probably it will be the title
![Figure_3](https://user-images.githubusercontent.com/26282714/57181460-5dd58400-6e94-11e9-8538-f2028d579e58.png)

___

## Text Detection

we apply only the title image to EAST
![Figure_1](https://user-images.githubusercontent.com/26282714/57181510-097ed400-6e95-11e9-8e5b-2e8f7f12a01d.png)

___

## Text Recognition

we use tesseract for text recognition
for thr image
![Figure_1](https://user-images.githubusercontent.com/26282714/57181510-097ed400-6e95-11e9-8e5b-2e8f7f12a01d.png)

The output text: </br>
(THIRD EDITION Textbook of Geotechnical Enoineering)

___

## Text Processing

we applied some simple text processing methods:</br>
    -removing punctuation. </br>
    -removing single characters from the list of results.</br>
    -removing duplication.</br>
