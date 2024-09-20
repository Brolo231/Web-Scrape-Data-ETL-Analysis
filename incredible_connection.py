import requests
from bs4 import BeautifulSoup
import csv
import re  # Import regular expression module

# Function to clean price and remove unwanted characters
def clean_text(text):
    return re.sub(r'\s+', ' ', text).strip()  # Replaces multiple spaces/newlines with a single space

# Function to scrape MacShack
def scrape_incredible_connection(url):
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
    }
    response = requests.get(url, headers=headers)
    soup = BeautifulSoup(response.text, 'html.parser')

    products = []

    for item in soup.find_all('div', class_='product-item-info'):  # Product container identifier
        # Debug: Print the HTML of the item to check its structure
        print(item.prettify())

        title_elem = item.find('strong', class_='product name product-item-name')
        title = clean_text(title_elem.text) if title_elem else 'N/A'

        print(title)

        # if 'GB' not in title: # Replace with GB where appropriate
            # continue

        price_elem = item.find('span', class_='price-container price-final_price tax weee')
        price = clean_text(price_elem.text) if price_elem else 'N/A'

        list_price_elem = item.find('span', class_='old-price')
        list_price = clean_text(list_price_elem.text) if list_price_elem else 'N/A'

        delivery_elem = item.find('span', class_='not_found')
        delivery = clean_text(delivery_elem.text) if delivery_elem else 'N/A'

        products.append([title, price, list_price, delivery])

    print(response.status_code)

    return products

# URL of the MacShack page to scrape
url = 'https://www.incredible.co.za/catalogsearch/result/?q=apple+watch' # apple watch
    # macbook #'https://www.incredible.co.za/catalogsearch/result/?q=macbook'
    # iPhone #'https://www.incredible.co.za/catalogsearch/result/?q=iPhone+'
    # iPhone 15 #'https://www.incredible.co.za/catalogsearch/result/?q=iPhone+15'

# Scrape data
data = scrape_incredible_connection(url)

# Save to CSV
with open('incredible_connection_products.csv', 'a', newline='', encoding='utf-8') as file:  # change 'w' to 'a' to append
    writer = csv.writer(file)
    # writer.writerow(['Title', 'Price', 'List Price', 'Delivery'])  # Omit to append additional contents
    writer.writerows(data)

print('Scraping completed and data saved to incredible_connection_products.csv')
