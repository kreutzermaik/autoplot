import os
import time
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options as ChromeOptions
from selenium.webdriver.chrome.service import Service as ChromeService
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.firefox.options import Options as FirefoxOptions
from selenium.webdriver.firefox.service import Service as FirefoxService
from webdriver_manager.firefox import GeckoDriverManager

# Paths
url = 'https://www.google.com/'
powerFile = '\csv\collectl.csv'


def init_driver(browser):
    if browser == "Chrome":
        options = ChromeOptions()
        driver = webdriver.Chrome(service=ChromeService(ChromeDriverManager().install()), options=options)
    elif browser == "Firefox":
        options = FirefoxOptions()
        options.add_argument("--headless")
        driver = webdriver.Firefox(service=FirefoxService(GeckoDriverManager().install()), options=options)
    return driver


def start_nutzungsszenario(browser):
    # Init Driver
    driver = init_driver(browser)

    # Open URL
    driver.get(url)

    # Wait and stop selenium
    time.sleep(10)
    driver.quit()


start_nutzungsszenario("Firefox")
