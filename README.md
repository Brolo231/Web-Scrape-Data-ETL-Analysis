# Web-Scrape-Data-ETL-Analysis
In this project, specific apple products were scraped from various web sites after which data cleaning and formatting was performed to allow for easier data visualization and analysis. 

<h1>Apple Products Web Scraping Project</h1>

<h2>Table of Contents</h2>
<ul>
    <li><a href="#prerequisites">Prerequisites</a></li>
    <li><a href="#web-scraping-with-beautifulsoup">Web Scraping with BeautifulSoup</a></li>
    <li><a href="#storing-data-in-csv-files">Storing Data in CSV Files</a></li>
    <li><a href="#etl-processes-with-mysql">ETL Processes with MySQL</a></li>
    <li><a href="#data-cleaning-and-normalization">Data Cleaning and Normalization</a></li>
    <li><a href="#data-visualization-with-power-bi">Data Visualization with Power BI</a></li>
    <li><a href="#screenshots">Screenshots</a></li>
    <li><a href="#conclusion">Conclusion</a></li>
</ul>

<h2 id="prerequisites">Prerequisites</h2>
<ul>
    <li>Python 3.x</li>
    <li>BeautifulSoup</li>
    <li>Requests</li>
    <li>MySQL</li>
    <li>Power BI</li>
</ul>

<h2 id="web-scraping-with-beautifulsoup">Web Scraping with BeautifulSoup</h2>
<p>I used BeautifulSoup and Requests libraries to scrape product data from the following websites:</p>
<ul>
    <li>Amazon</li>
    <li>Incredible Connection</li>
    <li>Machsack</li>
</ul>

<h2 id="storing-data-in-csv-files">Storing Data in CSV Files</h2>
<p>The scraped data is stored in CSV files with the following columns:</p>
<ul>
    <li>Title</li>
    <li>Price</li>
    <li>List Price</li>
    <li>Delivery</li>
</ul>

<h2 id="etl-processes-with-mysql">ETL Processes with MySQL</h2>
<p>The CSV files are imported into MySQL for ETL processes. This involves extracting the data, transforming it by cleaning and normalizing, and loading it into a MySQL database.</p>

<h2 id="data-cleaning-and-normalization">Data Cleaning and Normalization</h2>
<p>Data cleaning and normalization are performed to ensure consistency and accuracy. This includes removing duplicates, handling missing values, and standardizing formats.</p>

<h2 id="data-visualization-with-power-bi">Data Visualization with Power BI</h2>
<p>The cleaned data is imported into Power BI for visualization. Various charts and graphs are created to analyze the product data.</p>

<h2 id="screenshots">Screenshots</h2>
<p><img src="path/to/web_scraping_code_screenshot.png" alt="Web Scraping Code"></p>
<p><img src="path/to/csv_file_screenshot.png" alt="CSV File"></p>
<p><img src="path/to/mysql_import_screenshot.png" alt="MySQL Import"></p>
<p><img src="path/to/power_bi_visualization_screenshot.png" alt="Power BI Visualization"></p>

<h2 id="conclusion">Conclusion</h2>
<p>This project showcases the end-to-end process of web scraping, data cleaning, and visualization. By leveraging Python, MySQL, and Power BI, we can efficiently extract, transform, and analyze data from multiple sources.</p>
