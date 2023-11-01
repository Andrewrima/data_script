from selenium import webdriver
import os
import glob
from time import sleep

folder = r"C:\Users\andrew.machado\Desktop\temp\eze\\"
pattern = r"C:\Users\andrew.machado\Desktop\temp\eze\\*.msi"
files = glob.glob(pattern)

options = webdriver.ChromeOptions()

prefs = {"download.default_directory": folder,
         'safebrowsing.enabled': 'false'}

options.add_experimental_option("prefs", prefs)

driver = webdriver.Chrome(
    executable_path='C:\Python37\chromedriver.exe', chrome_options=options)


try:

    # Apaga o que tem dentro da pasta
    for file in files:
        os.remove(file)

    driver.get('https://www.ezesoft.com/downloads/download-ems')

    sleep(5)
    download = driver.find_elements_by_name('Eze-EMS64-2022.8.0.msi')

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
                pattern = r"C:\Users\andrew.machado\Desktop\temp\eze\\*.msi"
                files = glob.glob(pattern)
                driver.close()
                driver.quit()
                for file in files:
                    new_name = r"C:\Users\andrew.machado\Desktop\temp\eze\eze.msi"
                    os.rename(file, new_name)


except (Exception) as error:
    print(error)
