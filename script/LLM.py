import openai
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time


API_KEY = ""  # Global variable to store API key

def set_api_key():
    """Sets the OpenAI API key globally."""
    openai.api_key = API_KEY

def send_prompt(prompt, model="gpt-4o"):
    """
    Sends a structured prompt to GPT-4o or opens the ChatGPT Web UI if no API key is available.

    Args:
        prompt (str): The fully formatted prompt to send.
        model (str): The GPT model to use (default: gpt-4o).

    Returns:
        str: GPT-4o response or indication of using the Web UI.
    """
    if API_KEY is None:
        print("⚠️ No API key detected. Redirecting to ChatGPT Web UI...")
        open_chatgpt_web(prompt)
        return "ChatGPT Web UI opened."
    
    return send_prompt_to_gpt(prompt, model)

def send_prompt_to_gpt(prompt, model="gpt-4o"):
    """
    Sends a fully formatted prompt to GPT-4o and returns the response.

    Args:
        prompt (str): The fully formatted prompt.
        model (str): The GPT model to use.

    Returns:
        str: GPT-4o response or error message.
    """
    if API_KEY is None:
        return "Error: OpenAI API key is not set. Use `set_api_key(api_key)` first."
    set_api_key()
    try:
        response = openai.ChatCompletion.create(
            model=model,
            messages=[
                {"role": "system", "content": "You are a blockchain security expert analyzing smart contract vulnerabilities."},
                {"role": "user", "content": prompt}
            ],
            temperature=1.0 # set as default
        )
        return response["choices"][0]["message"]["content"].strip()
    except openai.error.OpenAIError as e:
        return f"OpenAI API Error: {e}"
    except Exception as e:
        return f"Unexpected Error: {e}"


def send_prompt_to_chatgpt(driver, prompt):
    """Finds and interacts with the ChatGPT input box, submits the prompt, and waits for a response."""
    
    time.sleep(5)  # Allow page to load

    # Click chat area to activate input
    try:
        chat_area = driver.find_element(By.TAG_NAME, "main")  # Main chat window
        driver.execute_script("arguments[0].click();", chat_area)
        print("✅ Clicked chat area to activate input.")
        time.sleep(2)
    except Exception as e:
        print(f"⚠️ Could not click chat area: {e}")

    # Debug: Find all textarea elements
    textareas = driver.find_elements(By.TAG_NAME, "textarea")
    print(f"🔍 Found {len(textareas)} `textarea` elements after clicking chat area.")

    if not textareas:
        print("❌ No `textarea` elements found. ChatGPT UI may have changed.")
        return

    # Try interacting with each textarea
    for idx, textarea in enumerate(textareas):
        textarea_display = textarea.value_of_css_property("display")
        print(f"📌 Checking `textarea` #{idx + 1} (display={textarea_display})")

        if textarea_display == "none":
            print(f"⚠️ `textarea` #{idx + 1} is **hidden**. Trying to make it visible...")
            driver.execute_script("arguments[0].style.display = 'block';", textarea)
            time.sleep(1)
            if textarea.value_of_css_property("display") == "none":
                print(f"⚠️ `textarea` #{idx + 1} is still hidden. Skipping...")
                continue

        try:
            driver.execute_script("arguments[0].scrollIntoView(true);", textarea)
            time.sleep(1)
            textarea.click()
            time.sleep(1)

            # Send the prompt using JavaScript
            driver.execute_script(
                "arguments[0].value = arguments[1]; arguments[0].dispatchEvent(new Event('input', { bubbles: true }));",
                textarea, prompt
            )
            time.sleep(1)

            # **Find the correct "Send" button**
            send_button = None

            # First, try finding by `aria-label="Send message"`
            try:
                send_button = driver.find_element(By.XPATH, "//button[@aria-label='Send message']")
                print("✅ Found 'Send' button using aria-label!")
            except:
                print("⚠️ Could not find 'Send' button by aria-label. Trying alternative methods...")

            # If not found, try locating the last button on the page
            if not send_button:
                buttons = driver.find_elements(By.TAG_NAME, "button")
                print(f"🔍 Found {len(buttons)} buttons on the page.")

                # Assume the last button is the "Send" button
                if buttons:
                    send_button = buttons[-1]
                    print("✅ Using the last detected button as 'Send' button.")

            if send_button:
                driver.execute_script("arguments[0].click();", send_button)
                print("✅ Prompt submitted successfully!")

                # **Step 4: Wait for ChatGPT's response**
                try:
                    WebDriverWait(driver, 20).until(
                        EC.presence_of_element_located((By.CSS_SELECTOR, 'div[class*="message"]'))
                    )
                    print("✅ Response detected!")
                except:
                    print("⚠️ No response found within timeout. ChatGPT may be slow.")

                return

            print("❌ Could not find the correct 'Send' button.")

        except Exception as e:
            print(f"⚠️ Error with `textarea` #{idx + 1}: {e}")

    print("❌ Could not send the prompt. No working input field found.")

def open_chatgpt_web(prompt):
    """Opens ChatGPT Web UI and submits the prompt automatically."""

    chatgpt_urls = ["https://chat.openai.com/", "https://chatgpt.com/"]
    print(f"\n🔗 Opening ChatGPT Web UI: {chatgpt_urls[0]}\n")

    # Set up Chrome options
    chrome_options = Options()
    chrome_options.add_argument("--start-maximized")  # Open in full screen
    chrome_options.add_argument("--no-sandbox")
    chrome_options.add_argument("--disable-dev-shm-usage")

    # Use existing logged-in Chrome profile to keep session
    chrome_options.add_argument("--user-data-dir=/root/.config/google-chrome")  # Path to Chrome data
    chrome_options.add_argument("--profile-directory=Default")  # Use 'Default' profile

    # Path to chromedriver
    chromedriver_path = "/usr/bin/chromedriver"

    # Set up the driver
    service = Service(chromedriver_path)
    driver = webdriver.Chrome(service=service, options=chrome_options)

    print("🛠 Opening ChatGPT website...")
    driver.get(chatgpt_urls[0])  # Try opening OpenAI's ChatGPT first
    time.sleep(5)  # Allow time for redirection

    # Debugging: Print current URL
    current_url = driver.current_url
    print(f"🔍 Current Page URL: {current_url}")

    # Check if it was redirected to a different domain
    if "chat.openai.com" not in current_url and "chatgpt.com" not in current_url:
        print("❌ ChatGPT did not load correctly. Trying alternative URL...")
        driver.get(chatgpt_urls[1])  # Try opening the new ChatGPT domain
        time.sleep(5)

    # Re-check current page
    current_url = driver.current_url
    if "chat.openai.com" not in current_url and "chatgpt.com" not in current_url:
        print("❌ ChatGPT is still not loading correctly. Please check manually.")
        driver.quit()
        return

    print("✅ ChatGPT opened successfully. Using existing login session.")

    # Send the prompt to ChatGPT
    send_prompt_to_chatgpt(driver, prompt)

    # Optionally, wait for the response and retrieve it
    time.sleep(5)
    try:
        responses = driver.find_elements(By.CSS_SELECTOR, "div.markdown")  # Update selector if needed
        if responses:
            last_response = responses[-1].text
            print("\n✅ Retrieved ChatGPT Response:\n", last_response)

            # Save the response
            output_file = "Reproduction.sol"
            with open(output_file, "w", encoding="utf-8") as f:
                f.write(last_response)

            print(f"\n✅ Solidity exploit saved to: {output_file}")
        else:
            print("⚠️ No responses found.")

    except Exception as e:
        print("⚠️ Error retrieving response:", e)

    driver.quit()