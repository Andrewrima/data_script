import pyautogui
import time
import subprocess
import sys

tempo_pressionamento = 2


def instalar_pacote(package):
    subprocess.check_call(
        [sys.executable, "-m", "pip", "install", package])


try:
    import pyautogui
except ImportError:
    instalar_pacote('pyautogui')
    import pyautogui

pyautogui.keyDown('shift')
pyautogui.keyDown('ctrl')
pyautogui.keyDown('winleft')
pyautogui.press('b')
time.sleep(tempo_pressionamento)
pyautogui.keyUp('shift')
pyautogui.keyUp('ctrl')
pyautogui.keyUp('winleft')
