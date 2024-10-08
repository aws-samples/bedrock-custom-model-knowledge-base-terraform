import json
from datasets import load_dataset

# Load the dataset
dataset = load_dataset("SohamNale/Banking_Dataset_for_LLM_Finetuning", split="train")

# Open a file to write the JSONL data
with open("banking_qa.jsonl", "w", encoding="utf-8") as jsonl_file:
    # Get the total number of rows
    total_rows = len(dataset)

    # Iterate through the dataset
    for index, row in enumerate(dataset, start=1):
        # Create a dictionary with question and answer
        qa_pair = {
            "question": row["question"],
            "answer": row["answer"]
        }

        # Write the JSON object to the file
        json.dump(qa_pair, jsonl_file, ensure_ascii=False)

        # Add a newline character if it's not the last line
        if index < total_rows:
            jsonl_file.write("\n")
