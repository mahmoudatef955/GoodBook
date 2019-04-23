from amazon.api import AmazonAPI


ACCESS_KEY = 'AKIAI3FFIB6W2LW6D36A'
SECRET = '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'
ASSOC = 'mahmoudatef95-21'
bookName = 'clean code'


amazon = AmazonAPI(ACCESS_KEY, SECRET, ASSOC)
results = amazon.search(Keywords = bookName, SearchIndex = "Books")
print(results)
for item in results:
    print item.title, item.isbn, item.price_and_currency