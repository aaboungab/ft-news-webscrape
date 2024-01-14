import os
import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin

BASE_URL = "https://www.ft.com"
RESULTS_DIR = "ft-news-results"
SECTIONS_FILE = "sections.txt"

def get_soup(url):
    headers = {'User-Agent': 'Mozilla/5.0'}
    try:
        response = requests.get(url, headers=headers)
        response.raise_for_status()
        return BeautifulSoup(response.content, 'html.parser')
    except requests.exceptions.HTTPError as err:
        raise SystemExit(err)

def extract_news(soup):
    return soup.find_all(class_="js-teaser-heading-link")

def write_to_file(news_items, filename):
    if not os.path.exists(RESULTS_DIR):
        os.makedirs(RESULTS_DIR)

    filepath = os.path.join(RESULTS_DIR, filename)
    with open(filepath, 'w') as file:
        for item in news_items:
            if item.name == 'a' and item.has_attr('href'):
                title = item.text.strip()
                link = urljoin(BASE_URL, item.get('href'))
                file.write(f"{title}\nLink:\t{link}\n\n")
                
def read_sections():
    """Read section names from a file."""
    with open(SECTIONS_FILE, 'r') as file:
        return [line.strip() for line in file if line.strip()]

def main():
    sections = read_sections()
    
    for section in sections:
        url = f"{BASE_URL}/{section}"
        soup = get_soup(url)
        news_items = extract_news(soup)
        filename = f"ftimes_news_{section}.txt"
        write_to_file(news_items, filename)
        print(f"News saved to {RESULTS_DIR} for {section}")

if __name__ == "__main__":
    main()
