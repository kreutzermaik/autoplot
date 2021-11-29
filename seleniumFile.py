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
url = 'http://127.0.0.1:7777/'
powerFile = '\csv\collectl.csv'


def init_driver(browser):
    if browser == "Chrome":
        options = ChromeOptions()
        options.add_argument("--headless")
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
    time.sleep(2)

    # Click "Upload Messdaten" Button
    driver.find_element(By.CSS_SELECTOR, "li:nth-child(2)").click()
    time.sleep(1)

    # Upload files
    driver.find_element(By.ID, "LogFileMM").send_keys(os.getcwd() + powerFile)
    time.sleep(1)
    driver.find_element(By.ID, "PowerFileMM").send_keys(os.getcwd() + powerFile)
    time.sleep(1)
    driver.find_element(By.ID, "PerformanceFileMM").send_keys(os.getcwd() + powerFile)
    time.sleep(1)
    driver.find_element(By.ID, "LogFileBL").send_keys(os.getcwd() + powerFile)
    time.sleep(1)
    driver.find_element(By.ID, "PowerFileBL").send_keys(os.getcwd() + powerFile)
    time.sleep(1)
    driver.find_element(By.ID, "PerformanceFileBL").send_keys(os.getcwd() + powerFile)

    time.sleep(3)

    # Click "Konfiguration Bericht" Button
    driver.find_element(By.CSS_SELECTOR, "li:nth-child(3)").click()
    time.sleep(1)

    # Click "Einstellungen speichern" Button
    driver.find_element(By.ID, "saveSettingsButton").click()
    time.sleep(1)

    # Click "Bericht erzeugen" Button
    driver.find_element(By.ID, "generateReportButton").click()

    # Wait and stop selenium
    time.sleep(5)
    driver.quit()


# start_nutzungsszenario("Chrome")
start_nutzungsszenario("Firefox")
