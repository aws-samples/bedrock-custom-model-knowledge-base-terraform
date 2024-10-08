import json

from datasets import load_dataset

# Load the dataset
dataset = load_dataset("SohamNale/Banking_Dataset_for_LLM_Finetuning", split="train")

with open("banking_qa.jsonl", "w", encoding="utf-8") as jsonl_file:
    total_rows = len(dataset)

    # Iterate through the dataset
    for index, row in enumerate(dataset, start=1):
        qa_pair = {
            "prompt": row["question"],
            "completion": row["answer"]
        }
        json.dump(qa_pair, jsonl_file, ensure_ascii=False)
        if index < total_rows:
            jsonl_file.write("\n")
