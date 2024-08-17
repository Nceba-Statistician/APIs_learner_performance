import pyodbc
import warnings
import pandas as pd
import numpy as np
from fastapi import FastAPI, HTTPException

warnings.filterwarnings("ignore")

conn = pyodbc.connect(
    "Driver={ODBC Driver 18 for SQL Server};"
    "Server=MRIYX05RCBV;"
    "Database=LearnerPerformanceDB;"
    "UID=c#_database;"
    "PWD=roots;"
    "TrustServerCertificate=yes;"
)

query = "select * from Student_performance_api"

Student_performance_api_df = pd.read_sql_query(query, conn)

# print(Student_performance_api_df)

Student_performance_api_df["Gender_ID"] = Student_performance_api_df["Gender"].map({True: "Male", False: "Female"})

GPA_averByAge = Student_performance_api_df.groupby(["Age", "Gender_ID"])["GPA"].mean().unstack().reset_index()

GPA_averByAge.columns = ["Age", "GPA (Male)", "GPA (Female)"]

print(Student_performance_api_df.head())

print(GPA_averByAge)
