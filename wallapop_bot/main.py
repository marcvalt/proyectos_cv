import requests
import json
import time
import telegram
import asyncio
import os
from dotenv import load_dotenv

load_dotenv()
# Telegram bot configuration in .env file
BOT_TOKEN = os.getenv('BOT_TOKEN')
CHAT_ID = os.getenv('CHAT_ID')

API_URL = "https://api.wallapop.com/api/v3/search"
ITEM_URL = "https://es.wallapop.com/item/"

# Parameters of search
PARAMS = {
        "keywords": "roland fp10",
        "longitude": -3.69196,
        "latitude": 40.41956,
        "filters_source": "search_box"
        }

HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:130.0) Gecko/20100101 Firefox/130.0",
    "Accept": "application/json, text/plain, */*",
    "Cache-Control": "no-cache",
    "Connection": "keep-alive",
    "DNT": "1",
    "DeviceOS": "0",
    "X-DeviceOS": "0",
    "Origin": "https://es.wallapop.com",
    "Pragma": "no-cache",
    "Referer": "https://es.wallapop.com/",
    "Sec-Fetch-Dest": "empty",
    "Sec-Fetch-Mode": "cors",
    "Sec-Fetch-Site": "same-site",
    "sec-ch-ua-mobile": "?0",
    "sec-ch-ua-platform": "\"Windows\""
}

PRODUCTS_FILE = "./product_ids.json"

# Delay between searches
SLEEP_TIME = 300

def load_product_ids():
    try:
        with open(PRODUCTS_FILE, "r") as file:
            return set(json.load(file))
    except FileNotFoundError:
        return set()

def save_product_ids(product_ids):
    with open(PRODUCTS_FILE, "w") as file:
        json.dump(list(product_ids), file)

async def send_telegram_message(bot, message, photo_url=None):
    if photo_url:
        await bot.send_photo(chat_id=CHAT_ID, photo=photo_url, caption=message, parse_mode="HTML")
    else:
        await bot.send_message(chat_id=CHAT_ID, text=message, parse_mode="HTML")

async def find_new_products():

    product_ids = load_product_ids()

    bot = telegram.Bot(token=BOT_TOKEN)

    while True:
        response = requests.get(API_URL, headers=HEADERS, params=PARAMS)

        if response.status_code == 200:
            data = response.json()
            search_objects = data["data"]["section"]["payload"]["items"]
            if search_objects:
                for product in search_objects:
                    product_id = product["id"]
                    if product_id not in product_ids:
                        product_ids.add(product_id)

                        # Relevant product info
                        title = product["title"]
                        description = product["description"]
                        price = product["price"]["amount"]
                        currency = product["price"]["currency"]
                        link = product["web_slug"]
                        photo_url = None

                        for image in product["images"]:
                            if image["urls"]["big"]:
                                photo_url = image["urls"]["big"]
                                break

                        product_url = ITEM_URL + link
                        print(f"New product found! \"{title}\", {price} {currency} ({product_url})")
                        message = f"<b>New product listed:</b>\n{title}\n\n<b>Description:</b>\n{description}\n\n<b>Price:</b> {price} {currency}\n\n<a href='{product_url}'>LINK</a>"
                        await send_telegram_message(bot, message, photo_url)

            else:
                message = "No new products found."
                print(message)
                await send_telegram_message(bot, message)
        else:
            message = f"Error: {response.status_code} - {response.text}"
            print(message)
            await send_telegram_message(bot, message)

        save_product_ids(product_ids)

        message = f"Waiting for {SLEEP_TIME} seconds..."
        print(message)
        await asyncio.sleep(SLEEP_TIME)

asyncio.run(find_new_products())
