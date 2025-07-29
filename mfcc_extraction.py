import os
import librosa
import numpy as np
import csv
import pandas as pd
from collections import Counter

def extract_mfcc_flat(file_path, sr=16000, duration=1.0, n_mfcc=13, max_len=98):
    try:
        samples = int(sr * duration)
        y, _ = librosa.load(file_path, sr=sr)
        
        # Handle audio length
        y = y[:samples] if len(y) > samples else np.pad(y, (0, samples - len(y)))
        
        # Extract MFCC
        mfcc = librosa.feature.mfcc(y=y, sr=sr, n_mfcc=n_mfcc)
        
        # Ensure consistent time dimension
        if mfcc.shape[1] < max_len:
            mfcc = np.pad(mfcc, ((0, 0), (0, max_len - mfcc.shape[1])), mode='constant')
        else:
            mfcc = mfcc[:, :max_len]
        
        # Flatten and validate
        mfcc_flat = mfcc.flatten()
        
        # Ensure exactly 1274 features
        if mfcc_flat.shape[0] != 1274:
            raise ValueError(f"Expected 1274 features, got {mfcc_flat.shape[0]}")
        
        # Replace any NaN or Inf with zeros
        mfcc_flat = np.nan_to_num(mfcc_flat, nan=0.0, posinf=0.0, neginf=0.0)
        
        return mfcc_flat  # shape: (1274,)
        
    except Exception as e:
        print(f"Error in extract_mfcc_flat for {file_path}: {e}")
        return None

def analyze_dataset(csv_file):
    print(f"\n📊 DATASET ANALYSIS for {csv_file}")
    print("=" * 50)
    
    try:
        # Read the CSV file
        df = pd.read_csv(csv_file, header=None)
        
        # Get basic info
        total_rows = len(df)
        total_features = len(df.columns) - 1  # -1 for the label column
        file_size_mb = os.path.getsize(csv_file) / (1024 * 1024)
        
        print(f" File size: {file_size_mb:.2f} MB")
        print(f" Total samples: {total_rows:,}")
        print(f" Features per sample: {total_features}")
        
        # Validate data integrity
        print(f"\n DATA VALIDATION:")
        print("-" * 25)
        
        # Check for consistent row length
        row_lengths = df.apply(len, axis=1)
        if row_lengths.nunique() == 1:
            print(f" All rows have consistent length: {row_lengths.iloc[0]}")
        else:
            print(f" Inconsistent row lengths found: {row_lengths.unique()}")
        
        # Check for missing values
        missing_count = df.isnull().sum().sum()
        if missing_count == 0:
            print(" No missing values (NaN)")
        else:
            print(f" Found {missing_count} missing values")
        
        # Check feature columns for non-numeric data
        feature_cols = df.iloc[:, :-1]  # All except last column
        try:
            feature_cols.astype(float)
            print(" All feature columns are numeric")
        except:
            print(" Some feature columns contain non-numeric data")
        
        # Check if expected size (1275 columns = 1274 features + 1 label)
        expected_cols = 1275
        if len(df.columns) == expected_cols:
            print(f" Correct column count: {len(df.columns)} (1274 features + 1 label)")
        else:
            print(f" Expected {expected_cols} columns, got {len(df.columns)}")
        
        # Get label counts (last column contains labels)
        labels = df.iloc[:, -1]  # Last column
        label_counts = Counter(labels)
        
        print(f"\n  LABEL DISTRIBUTION:")
        print("-" * 30)
        for label, count in sorted(label_counts.items()):
            percentage = (count / total_rows) * 100
            print(f"{label:>10}: {count:>5} samples ({percentage:>5.1f}%)")
        
        print(f"\n📈 STATISTICS:")
        print("-" * 20)
        print(f"Min samples per class: {min(label_counts.values())}")
        print(f"Max samples per class: {max(label_counts.values())}")
        print(f"Avg samples per class: {sum(label_counts.values()) / len(label_counts):.1f}")
        print(f"Total unique labels: {len(label_counts)}")
        
        return label_counts, total_rows, file_size_mb
        
    except FileNotFoundError:
        print(f" File not found: {csv_file}")
        return None, 0, 0
    except Exception as e:
        print(f" Error reading file: {e}")
        return None, 0, 0

# Path setup
base_path = 'C:/Users/smmee/OneDrive/Desktop/KWS_Project/Project_Data'
# Filter out non-keyword folders like '_background_noise_' and files
all_items = os.listdir(base_path)
keywords = sorted([item for item in all_items if os.path.isdir(os.path.join(base_path, item)) and not item.startswith('_')])
print(f"Found keywords: {keywords}")
output_csv = 'C:/Users/smmee/OneDrive/Desktop/KWS_Project/mfcc_dataset.csv'

# Write CSV with strict validation
print("🔍 Creating validated CSV dataset...")
processed_count = 0
error_count = 0

with open(output_csv, mode='w', newline='', encoding='utf-8') as f:
    writer = csv.writer(f, quoting=csv.QUOTE_MINIMAL)
    
    for label in keywords:
        folder = os.path.join(base_path, label)
        if not os.path.isdir(folder):
            continue
        print(f"Processing {label}...")
        
        for fname in os.listdir(folder):
            if fname.endswith('.wav'):
                file_path = os.path.join(folder, fname)
                try:
                    mfcc_flat = extract_mfcc_flat(file_path)
                    
                    # Validation checks
                    if mfcc_flat is None:
                        print(f"⚠️  Skipping {fname}: MFCC extraction returned None")
                        error_count += 1
                        continue
                    
                    if len(mfcc_flat) != 1274:
                        print(f"⚠️  Skipping {fname}: Expected 1274 features, got {len(mfcc_flat)}")
                        error_count += 1
                        continue
                    
                    if np.any(np.isnan(mfcc_flat)) or np.any(np.isinf(mfcc_flat)):
                        print(f"⚠️  Skipping {fname}: Contains NaN or Inf values")
                        error_count += 1
                        continue
                    
                    # Clean the label (remove any problematic characters)
                    clean_label = str(label).strip()
                    
                    # Create row: 1274 features + 1 label = 1275 total
                    row = [float(x) for x in mfcc_flat] + [clean_label]
                    
                    # Final validation
                    if len(row) != 1275:
                        print(f"⚠  Skipping {fname}: Row length {len(row)} != 1275")
                        error_count += 1
                        continue
                    
                    writer.writerow(row)
                    processed_count += 1
                    
                except Exception as e:
                    print(f" Error processing {file_path}: {e}")
                    error_count += 1
                    continue

print(f" CSV dataset created successfully!")
print(f" Processed: {processed_count} samples")
print(f" Errors: {error_count} samples")
print(f" Saved to: {output_csv}")

# Analyze the dataset
analyze_dataset(output_csv)
