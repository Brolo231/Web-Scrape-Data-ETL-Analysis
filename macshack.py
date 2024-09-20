import requests
from bs4 import BeautifulSoup
import csv
import re 

# Function to clean price and remove unwanted characters
def clean_text(text):
    return re.sub(r'\s+', ' ', text).strip()  # Replaces multiple spaces/newlines with a single space

# Function to scrape MacShack
def scrape_macshack(url):
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
    }
    response = requests.get(url, headers=headers)
    soup = BeautifulSoup(response.text, 'html.parser')

    products = []

    for item in soup.find_all('div', class_='card card-product'):  # Product container identifier
        # Debug: Print the HTML of the item to check its structure
        print(item.prettify())

        title_elem = item.find('h3', class_='card-heading typography-body')
        title = clean_text(title_elem.text) if title_elem else 'N/A'

        print(title)

        # can be omitted for sites that only show specific product # if 'GB' not in title: # Replace with GB where appropriate
            #continue

        price_elem = item.find('span', class_='price-item price-item-sale price-item-last')
        price = clean_text(price_elem.text) if price_elem else 'N/A'

        list_price_elem = item.find('s', class_='price-item-regular')
        list_price = clean_text(list_price_elem.text) if list_price_elem else 'N/A'

        delivery_elem = item.find('span', class_='not_found')
        delivery = clean_text(delivery_elem.text) if delivery_elem else 'N/A'

        products.append([title, price, list_price, delivery])

    print(response.status_code)

    return products

# URL of the MacShack page to scrape
url = 'https://macshack.co.za/collections/apple-watch'
    # macbook # 'https://macshack.co.za/collections/all-apple-macs?filter.p.m.custom.size=13-Inch&filter.p.m.custom.size=14-Inch&filter.p.m.custom.size=16-Inch&filter.p.m.custom.size=24-Inch&filter.p.m.custom.memory=8GB&filter.p.m.custom.memory=16GB&filter.p.m.custom.storage=256GB+SSD&filter.p.m.custom.storage=512GB+SSD&filter.p.m.custom.storage=1TB+SSD&filter.p.m.custom.processor=Apple+M1+8c+CPU+%2F+7c+GPU&filter.p.m.custom.processor=Apple+M1+8c+CPU+%2F+8c+GPU&filter.p.m.custom.processor=Apple+M1+Pro+10c+CPU+%2F+16c+GPU&filter.p.m.custom.processor=Apple+M1+Pro+12c+CPU+%2F+19c+GPU&filter.p.m.custom.processor=Apple+M1+Pro+8c+CPU+%2F+14c+GPU&filter.p.m.custom.processor=Apple+M3+8c+CPU+%2F+10c+GPU&filter.p.m.custom.processor=Apple+M3+8c+CPU+%2F+8c+GPU&filter.v.price.gte=&filter.v.price.lte=&sort_by=price-ascending'
    # iPhone #'https://macshack.co.za/collections/iphone?filter.p.m.custom.model=iPhone+12+Pro+Max&filter.p.m.custom.model=iPhone+13&filter.p.m.custom.model=iPhone+13+Pro&filter.p.m.custom.model=iPhone+13+Pro+Max&filter.p.m.custom.model=iPhone+14&filter.p.m.custom.model=iPhone+14+Plus&filter.p.m.custom.model=iPhone+14+Pro&filter.p.m.custom.model=iPhone+14+Pro+Max&filter.p.m.custom.model=iPhone+15+Plus&filter.p.m.custom.model=iPhone+15+Pro+Max&filter.v.price.gte=&filter.v.price.lte=&sort_by=price-ascending'

# Scrape data
data = scrape_macshack(url)

# Save to CSV
with open('macshack_products.csv', 'a', newline='', encoding='utf-8') as file:  # change 'w' to 'a' to append
    writer = csv.writer(file)
    # writer.writerow(['Title', 'Price', 'List Price', 'Delivery'])  # Omit to append additional contents
    writer.writerows(data)

print('Scraping completed and data saved to macshack_products.csv')
