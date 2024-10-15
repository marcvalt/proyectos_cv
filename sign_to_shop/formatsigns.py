import re
import os
import time
import pandas as pd
from dotenv import load_dotenv

load_dotenv()
API_URL = os.getenv('URL_API')
USERNAME = os.getenv('USERNAME')
PASSWORD = os.getenv('PASSWORD')

RAW_PATH = "signs_raw.txt"
JSON_PATH = "signs.json"
CSV_PATH = "signs.csv"

FILEBROWSERUPLOAD_PATH = ".\lib\\filebrowser-upload"
CSVTOTABLE_PATH = ".\lib\csvtotable.exe"

# convert raw signs to json format
def convert_json(newFile, jsonFile):
    data = open_file(newFile)

    data = re.sub(r'(?m)(?<=Text1: ).*({\"color\":\"(dark_(blue|red))\",\"text\":\"(\[(buy|sell)\]).*\"})', '\g<4> (\g<2> color)', data) # replace Text1: with the shop type
    data = re.sub(r'(?m)(?<=Text\d: ).*\"text\":\"(\\\")?(.*[^\"])(\\\")?\"}.*', '\g<2>', data) # leave only the text
    data = re.sub(r'(?m)(?<=Text\d: ).*\"text\":\"\"}.*', 'N/A', data)  # remove empty text
    data = re.sub(r'(?sm)x: (-?\d+).*?y: (-?\d+).*?z: (-?\d+)', 'xyz: \g<1>, \g<2>, \g<3>', data)  # combine xyz coords into 1 line
    data = re.sub(r'(?sm)xyz:(?=((?!xyz:).)*Text1:(?! \[(buy|sell)\])).*?\n\n', '', data) # remove signs without a shop
    data = re.sub(r'(?sm)xyz:(?=((?!xyz:).)*Text1:(?= \[(buy|sell)\]$)).*?\n\n', '', data) # remove false positives
    data = re.sub(r'(?m)(^Color:.*$)|(^id:.*sign$)', '', data)  # remove color and id lines
    data = re.sub(r'(?m)(^$\n)', '', data)  # remove empty lines
    data = re.sub(r'(?sm)(?=\nxyz)', '\n', data)  # insert newline before xyz
    data = re.sub(r'(?sm)$(?!\n)', '\n', data)  # insert newline at end of file
    data = re.sub(r'(?m)(^$\n)', '', data)  # remove empty lines

    # JSON FORMATTING

    data = re.sub(r'(?m)^(xyz): (.*$)', '{\n"\g<1>": "\g<2>",', data) # create xyz field
    data = re.sub(r'(?m)^Text([1-3]): (.*$)', '"text\g<1>": "\g<2>",', data) # create text fields

    # price format
    data = re.sub(r'(?m)^Text(4):.*?(((\d*[\.,])*\d+)|N/A).*', '"price": "\g<2>"\n},', data)
    data = re.sub(r'(?m)^\"price\": \"(.*),(.*)\"$', '\"price\": \"\g<1>\g<2>\"', data)
    # data = re.sub(r'(?m)^\"xyz\": \"(-?\d*), (-?\d*), (-?\d*)(\",$)', '"coordinates": [{\n"x": \g<1>, "y": \g<2>, "z": \g<3>\n}\n],', data)
    data = re.sub(r'(?m)^\"price\": \"(.*)\"$', '\"price\": \g<1>', data)
    data = re.sub(r'(?m)^\"price\": (\..*)', '\"price\": 0\g<1>', data)
    data = re.sub(r'(?m)^\"price\": (\..*)', '\"price\": 0\g<1>', data)
    data = re.sub(r'(?m)^\"price\": N/A', '\"price\": 0', data)

    # split shop type and stock status on different fields
    data = re.sub(r'(?m)(\"text1\": \"\[(sell|buy)\].*(\",$))', '\g<1>\n"offer": "\g<2>",', data)
    data = re.sub(r'(?m)^\"text1.*dark_blue.*(\",$)', '"on_stock": true,', data)
    data = re.sub(r'(?m)^\"text1.*dark_red.*(\",$)', '"on_stock": false,', data)

    # get text2 and text3 into a single field
    data = re.sub(r'(?sm)^\"text2\": \"([^\"]*)\",$\n^\"text3\": \"([^\"]*)\",$', '"text": "\g<1> | \g<2>",', data)

    # separate xyz to x, y, z and add link to the location
    data = re.sub(r'(?m)^\"xyz\": \"(-?\d*), (-?\d*), (-?\d*)(\",$)', '"link": "https://map.piratemc.com/survival#PirateCraft_1;flat;\g<1>,\g<2>,\g<3>;6",\n"x": \g<1>,\n"y": \g<2>,\n"z": \g<3>,', data)

    # remove , at end of line
    data = re.sub(r'(?sm),\s*\Z', '', data)

    # open array at start of file
    data = "[\n" + data + "]"

    write(jsonFile, data)

# convert json file to csv file
def convert_json_csv(jsonFile, csvFile):
    df = pd.read_json(jsonFile, encoding='ISO-8859-1')
    df = df.reindex(columns=['offer', 'text', 'price', 'on_stock', 'x', 'y', 'z', 'link'])
    df.to_csv(csvFile, index=None)
    os.system('csvtotable --caption "Sign shops - updated: ' + time.strftime(
        "%H:%M:%S %d-%m-%Y") + '" --overwrite --export-options copy signs.csv signs.html')

# opens file and returns the contents
def open_file(file):
    f = open(file, "r")
    data = f.read()
    f.close()
    return data

# writes current time and contents to file
def write(file, data, writeDate=False):
    f = open(file, "w")
    # write current time to file
    if writeDate:
        f.write(time.strftime("%Y-%m-%d %H:%M:%S") + "\n\n")
    f.write(data)
    f.close()

# upload file to filebrowser server
def upload_filebrowser(file, name):
    if os.path.isfile(file):
        command = f'python {FILEBROWSERUPLOAD_PATH} --api {API_URL} --username {USERNAME} --password {PASSWORD} --override --dest www/{name} {file}'
        os.system(command)
    else:
        print('File ' + file + ' does not exist')

def remove(file):
    os.remove(file)

def main():
    convert_json(RAW_PATH, JSON_PATH)
    convert_json_csv(JSON_PATH, CSV_PATH)
    upload_filebrowser("signs.html", "shop.html")

if __name__ == "__main__":
    main()
