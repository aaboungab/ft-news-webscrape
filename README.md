# Financial Times News Scraper

## Description
This script is designed to scrape news headlines and links from various sections of the Financial Times website (https://www.ft.com). It reads the section names from an external file, scrapes the corresponding data, and saves it in separate text files organized in a specific directory.

## Features
- Dynamic section scraping: Automatically extracts content from user-defined sections of the Financial Times website.
- Organized output: Saves scraped data in a structured format in separate text files for each section.
- Customizable: Users can specify which sections to scrape through a simple text file.


## Requirements
- Python 3
- `requests`
- `beautifulsoup4`

## Installation
First, ensure that Python 3 is installed on your system. Then, install the necessary Python packages using pip:

```bash
pip install requests beautifulsoup4
```

## Usage
Setup Sections File: Create a text file named sections.txt in the same directory as the script. Each line in this file should contain a section name from the Financial Times website, such as companies, world, tech, etc.

Run the Script: Execute the script with Python:
```bash
python ft_scraper.py
```

This will scrape the data from the specified sections and save it in the ft-news-results directory. Each section's data will be in a separate file named in the format ftimes_news_{section}.txt.

## Note
This script is intended for educational purposes and personal use. Scraping content from websites might be against the terms of service of the website. Ensure you are compliant with the Financial Times' terms of service and use the script responsibly. Consider using official APIs if available for commercial purposes.

