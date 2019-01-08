import pandas as pd
import sys

def output_predictions(test_path, pred_path, out_path, topic):
    test = pd.read_csv(test_path, delimiter='\t', header=0, encoding = "latin-1")
    if topic is not None:
        test = test.loc[test["Target"] == topic].reset_index()
    def clean_ascii(text):
        # function to remove non-ASCII chars from data
        return ''.join(i for i in text if ord(i) < 128)
    test['Tweet'] = test['Tweet'].apply(clean_ascii)
    #print(test)
    pred = pd.read_csv(pred_path, header=0, delimiter='\t')
    #print(pred)
    pred['prediction'] = pred['prediction'].astype('int64')
    df = test.join(pred)
    #print(df)
    stances = ["AGAINST", "FAVOR", "NONE", "UNKNOWN"]
    df["Stance"] = df["prediction"].apply(lambda i: stances[i])
    df = df[["index", "Target", "Tweet", "Stance"]]
    class_nums = {s: i for i, s in enumerate(stances)}
    df.to_csv(out_path, sep='\t', index=False, header=['ID', 'Target', 'Tweet', 'Stance'])

if __name__ == "__main__":
    test_path, pred_path, out_path = sys.argv[1:4]
    topic = None
    if len(sys.argv) > 4:
        topic = sys.argv[4]
    output_predictions(test_path, pred_path, out_path, topic)
