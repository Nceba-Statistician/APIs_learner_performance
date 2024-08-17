import requests
import pandas as pd

response = requests.get("http://127.0.0.1:8000/items_get").json()
print(pd.DataFrame(response).head())
print(pd.DataFrame(response).columns.tolist())
