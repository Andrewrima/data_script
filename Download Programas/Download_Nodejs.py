from selenium import webdriver
from selenium.webdriver.chrome.service import Service
import os
import glob
from time import sleep

folder = r"\\SERVIDOR\TI\Disks\NodeJs\\"
pattern = r"\\SERVIDOR\TI\Disks\NodeJs\\*.msi"
files = glob.glob(pattern)
service = Service(r"C:\Python37\chromedriver.exe")

options = webdriver.ChromeOptions()

prefs = {"download.default_directory": folder,
         'safebrowsing.enabled': 'false'}

options.add_experimental_option("prefs", prefs)


driver = webdriver.Chrome(service=service, options=options)

try:

    # Apaga o que tem dentro da pasta
    for file in files:
        os.remove(file)

    driver.get('https://nodejs.org/en/')

    # download = driver.find_element_by_xpath('//*[@id="home-intro"]/div[1]/a')
    download = driver.find_element("xpath", '//*[@id="home-intro"]/div[1]/a')

    download.click()

    # Wait until download completed
    fileends = "crdownload"
    while "crdownload" in fileends:
        sleep(1)
        for fname in os.listdir(folder):
            if "crdownload" in fname:
                fileends = "crdownload"
            else:
                fileends = "None"
                pattern = r"\\SERVIDOR\TI\Disks\NodeJs\\*.msi"
                files = glob.glob(pattern)
                for file in files:
                    new_name = r"\\SERVIDOR\TI\Disks\NodeJs\Node.msi"
                    os.rename(file, new_name)


except (Exception) as error:
    print(error)

finally:
    driver.close()
    driver.quit()
