import glob, argparse, os, subprocess
from random import choice


def main():
    parser = argparse.ArgumentParser(description="Transmit mp3 and wav files in your folder.")
    parser.add_argument("-f", "--freq", type=float, default=100.0, help="frequency (default: 100.0)")
    parser.add_argument("-d", "--dir", type=str, default="music", help="your folder (default: ./music)")
    parser.add_argument("-l", "--loop", action="store_true", help="playback mode: loop")
    parser.add_argument("-s", "--shuffle", action="store_true", help="playback mode: shuffle (default)")
    args = parser.parse_args()
    files = glob.glob(os.path.join(args.dir, "*.wav")) + glob.glob(os.path.join(args.dir, "*.mp3"))

    if len(files) == 0:
        print("Error: Can't find any mp3 or wav files in the folder.")
        exit(1)
    if args.loop and args.shuffle:
        print("Invalid argument: can't enable both loop and shuffle")
        exit(1)

    if args.shuffle:
        while True:
            play(choice(files), args)
    else:
        while True:
            for file in files:
                play(file, args)

sample_rate = "22050"
channels = "2"

def play(file, args):
    command = ["sox", f"\"{file}\"", "-r", sample_rate, "-c", channels, "-b", "16", "-t", "wav", "-", 
               "|", "sudo", os.path.join("target","fm_transmitter"), "-f", str(args.freq), "-"]
    print(f"Playing: {file}")
    result = subprocess.run(' '.join(command), shell=True, capture_output=True, text=True)
    if result.returncode != 0:
        print(f"Error: {result.stderr}")
        exit(1)


if __name__ == "__main__":
    main()