import requests
from bs4 import BeautifulSoup
import csv


# Function to scrape Amazon
def scrape_amazon(url):
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
    }
    response = requests.get(url, headers=headers)
    soup = BeautifulSoup(response.text, 'html.parser')

    products = []

    for item in soup.find_all('div', class_='sg-col-inner'):  # Product container identifier
        # Debug: Print the HTML of the item to check its structure
        print(item.prettify())

        title_elem = item.find('span', class_='a-size-base-plus a-color-base a-text-normal')
        title = title_elem.text if title_elem else 'N/A'

        if 'GPS' not in title: # Change to GB when appropriate
            continue

        price_elem = item.find('span', class_='a-price-whole')
        price = price_elem.text if price_elem else 'N/A'

        list_price_elem = item.find('span', class_='a-price a-text-price')
        list_price = list_price_elem.text if list_price_elem else 'N/A'

        delivery_elem = item.find('span', class_='a-color-base a-text-bold')
        delivery = delivery_elem.text if delivery_elem else 'N/A'

        products.append([title, price, list_price, delivery])

    return products


# URL of the Amazon page to scrape
url = 'https://www.amazon.co.za/s?k=apple+watch&crid=3J94TV881YD9V&sprefix=apple+watch%2Caps%2C246&ref=nb_sb_noss_2' #apple watch
    # macbook #'https://www.amazon.co.za/s?k=macboook&crid=36E3BH0FNLI47&sprefix=macboook+%2Caps%2C286&ref=nb_sb_noss_2'
    # 'https://www.amazon.co.za/s?k=iphone+14&crid=23B6368ZJZ07R&sprefix=iphone+14%2Caps%2C456&ref=nb_sb_noss_2' # iPhone 14
    # 'Price High to Low' 'https://www.amazon.co.za/s?k=iphone+15&s=price-desc-rank&crid=S6YUN16V274A&qid=1726163782&sprefix=iphone+14%2Caps%2C259&ref=sr_st_price-desc-rank&ds=v1%3AA8q24TXom5%2FeJggZWtebUc5w5kggiLY8TzU%2BRvErVFc'
    # 'iPhone 15' 'https://www.amazon.co.za/s?k=iphone+15&crid=S6YUN16V274A&sprefix=iphone+14%2Caps%2C259&ref=nb_sb_noss_2'

# Scrape data
data = scrape_amazon(url)

# Save to CSV
with open('amazon_products.csv', 'a', newline='', encoding='utf-8') as file: # change w (write) to a (append)
    writer = csv.writer(file)
    # writer.writerow(['Title', 'Price', 'List Price', 'Delivery']) # Omit to append additional contents
    writer.writerows(data)

print('Scraping completed and data saved to amazon_products.csv')
