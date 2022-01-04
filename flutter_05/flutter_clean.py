import os

for d in os.listdir():
    if os.path.isdir(d):
        d = f"./{d}"
        if os.path.exists(f"{d}/pubspec.yaml"):
            print(f"Clean up Flutter project {d} ...")
            os.chdir(d)
            os.system("flutter clean")
            os.chdir("..")
            print()
        
    