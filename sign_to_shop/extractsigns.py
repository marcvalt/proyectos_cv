import os
import subprocess

MCAS_FOLDER = "mcas"
SIGNS_FILE = "signs_raw.txt"
NBT_PATH = "lib/nbt/NBTUtil.exe"


def get_mcas():
    file_list = []
    for _, _, files in os.walk(MCAS_FOLDER):
        for file_name in files:
            if file_name.endswith(".mca"):
                file_list.append(file_name)
    return file_list


def get_nbt(files):
    for file_name in files:
        command = f'{NBT_PATH} --path={MCAS_FOLDER}/{file_name} --printtree'
        with open(f'{file_name}.txt', "w") as outfile:
            subprocess.run(command, stdout=outfile)
    outfile.close()


def extract_signs(output):
    for _, _, files in os.walk("."):
        for file_name in files:
            if file_name.endswith(".mca.txt"):
                with open(file_name, 'r') as f:
                    with open(output, 'w') as fo:
                        lines = f.read().splitlines()
                        for i, line in enumerate(lines):
                            if "id: minecraft:sign" in line:
                                # write last 3 lines and 4 following lines after sign id
                                for k in range(i-4, i+5):
                                    fo.write('\n'+lines[k].lstrip('| + '))
                                fo.write('\n')
                        fo.close()
                    f.close()


def clean_temp_files():
    for _, _, files in os.walk("."):
        for file_name in files:
            if file_name.endswith(".mca.txt"):
                print(file_name, "deleted")
                os.remove(file_name)


def main():
    print('Finding MCA files...')
    mca_files = get_mcas()
    print(f'Getting NBT data from MCA files found ({mca_files})...')
    get_nbt(mca_files)
    print('Extracting only signs nbt data...')
    extract_signs(SIGNS_FILE)
    print('Removing unnecessary files...')
    clean_temp_files()
    print('Done.')


if __name__ == "__main__":
    main()
