# Made by Ecys — https://ecys.xyz

# Made by Ecys — https://ecys.xyz

#!/bin/bash
# For Rofi Beats to play online Music or Locally save media files

# Directory local music folder
mDIR="$HOME/Music/"

# Directory for icons
iDIR="$HOME/.config/swaync/icons"

# Quran recitations
declare -A quran_recitations=(
  ["Surat Al-Fatihah 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/001.mp3"
  ["Surat Al-Baqarah 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/002.mp3"
  ["Surat Ali'Imran 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/003.mp3"
  ["Surat Al-Nisa 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/004.mp3"
  ["Surat Al-Ma'idah 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/005.mp3"
  ["Surat Al-An'am 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/006.mp3"
  ["Surat Al-A'raf 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/007.mp3"
  ["Surat Al-Anfal 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/008.mp3"
  ["Surat At-Tawbah 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/009.mp3"
  ["Surat Yunus 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/010.mp3"
  ["Surat Hud 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/011.mp3"
  ["Surat Yusuf 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/012.mp3"
  ["Surat Ar-Ra'd 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/013.mp3"
  ["Surat Ibrahim 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/014.mp3"
  ["Surat Al-Hijr 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/015.mp3"
  ["Surat An-Nahl 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/016.mp3"
  ["Surat Al-Isra 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/017.mp3"
  ["Surat Al-Kahf 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/018.mp3"
  ["Surat Maryam 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/019.mp3"
  ["Surat Ta-Ha 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/020.mp3"
  ["Surat Al-Anbiya 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/021.mp3"
  ["Surat Al-Hajj 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/022.mp3"
  ["Surat Al-Mu'minun 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/023.mp3"
  ["Surat An-Nur 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/024.mp3"
  ["Surat Al-Furqan 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/025.mp3"
  ["Surat Ash-Shu'ara 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/026.mp3"
  ["Surat An-Naml 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/027.mp3"
  ["Surat Al-Qasas 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/028.mp3"
  ["Surat Al-Ankabut 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/029.mp3"
  ["Surat Ar-Rum 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/030.mp3"
  ["Surat Luqman 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/031.mp3"
  ["Surat As-Sajda 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/032.mp3"
  ["Surat Al-Ahzab 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/033.mp3"
  ["Surat Saba 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/034.mp3"
  ["Surat Fatir 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/035.mp3"
  ["Surat Ya-Sin 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/036.mp3"
  ["Surat As-Saffat 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/037.mp3"
  ["Surat Sad 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_38"
  ["Surat Az-Zumar 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/039.mp3"
  ["Surat Ghafir 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/040.mp3"
  ["Surat Fussilat 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/041.mp3"
  ["Surat Ash-Shura 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/042.mp3"
  ["Surat Az-Zukhruf 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/043.mp3"
  ["Surat Ad-Dukhan 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/044.mp3"
  ["Surat Al-Jathiya 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/045.mp3"
  ["Surat Al-Ahqaf 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/046.mp3"
  ["Surat Muhammad 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/047.mp3"
  ["Surat Al-Fath 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/048.mp3"
  ["Surat Al-Hujurat 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/049.mp3"
  ["Surat Qaf 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/050.mp3"
  ["Surat Adh-Dhariyat 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/051.mp3"
  ["Surat At-Tur 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/052.mp3"
  ["Surat An-Najm 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/053.mp3"
  ["Surat Al-Qamar 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/054.mp3"
  ["Surat Ar-Rahman 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/055.mp3"
  ["Surat Al-Waqia 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/056.mp3"
  ["Surat Al-Hadid 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/057.mp3"
  ["Surat Al-Mujadila 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/058.mp3"
  ["Surat Al-Hashr 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/059.mp3"
  ["Surat Al-Mumtahanah 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/060.mp3"
  ["Surat As-Saff 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/061.mp3"
  ["Surat Al-Jumuah 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/062.mp3"
  ["Surat Al-Munafiqun 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/063.mp3"
  ["Surat At-Taghabun 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/064.mp3"
  ["Surat At-Talaq 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/065.mp3"
  ["Surat At-Tahrim 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/066.mp3"
  ["Surat Al-Mulk 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/067.mp3"
  ["Surat Al-Qalam 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/068.mp3"
  ["Surat Al-Haaqqa 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/069.mp3"
  ["Surat Al-Maarij 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/070.mp3"
  ["Surat Nuh 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/071.mp3"
  ["Surat Al-Jinn 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/072.mp3"
  ["Surat Al-Muzzammil 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/073.mp3"
  ["Surat Al-Muddaththir 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/074.mp3"
  ["Surat Al-Qiyama 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/075.mp3"
  ["Surat Al-Insan 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/076.mp3"
  ["Surat Al-Mursalat 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/077.mp3"
  ["Surat An-Naba 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/078.mp3"
  ["Surat An-Naziat 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/079.mp3"
  ["Surat Abasa 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/080.mp3"
  ["Surat At-Takwir 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/081.mp3"
  ["Surat Al-Infitar 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/082.mp3"
  ["Surat Al-Mutaffifin 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/083.mp3"
  ["Surat Al-Inshiqaq 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/084.mp3"
  ["Surat Al-Buruj 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/085.mp3"
  ["Surat At-Tariq 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/086.mp3"
  ["Surat Al-Ala 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/087.mp3"
  ["Surat Al-Ghashiyah 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/088.mp3"
  ["Surat Al-Fajr 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/089.mp3"
  ["Surat Al-Balad 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/090.mp3"
  ["Surat Ash-Shams 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al3afasee/091.mp3"
  ["Surat Al-Lail 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/092.mp3"
  ["Surat Ad-Duha 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/093.mp3"
  ["Surat Ash-Sharh 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/094.mp3"
  ["Surat At-Tin 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/095.mp3"
  ["Surat Al-Alaq 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/096.mp3"
  ["Surat Al-Qadr 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/097.mp3"
  ["Surat Al-Bayyina 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/098.mp3"
  ["Surat Az-Zalzala 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/099.mp3"
  ["Surat Al-Adiyat 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/100.mp3"
  ["Surat Al-Qaria 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/101.mp3"
  ["Surat At-Takathur 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/102.mp3"
  ["Surat Al-Asr 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/103.mp3"
  ["Surat Al-Humazah 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/104.mp3"
  ["Surat Al-Fil 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/105.mp3"
  ["Surat Quraysh 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/106.mp3"
  ["Surat Al-Maun 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/107.mp3"
  ["Surat Al-Kawthar 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/108.mp3"
  ["Surat Al-Kafirun 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/109.mp3"
  ["Surat An-Nasr 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/110.mp3"
  ["Surat Al-Masad 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/111.mp3"
  ["Surat Al-Ikhlas 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/112.mp3"
  ["Surat Al-Falaq 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/113.mp3"
  ["Surat An-Nas 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/114.mp3"
)
# Online Stations. Edit as required
declare -A online_music=(
  ["AfroBeatz 2024 🎧"]="https://www.youtube.com/watch?v=7uB-Eh9XVZQ"
  ["Lofi Girl ☕️🎶"]="https://play.streamafrica.net/lofiradio"
  ["Easy Rock 96.3 FM 📻🎶"]="https://radio-stations-philippines.com/easy-rock"
  ["Wish 107.5 FM 📻🎶"]="https://radio-stations-philippines.com/dwnu-1075-wish"
  ["Wish 107.5 YT Pinoy HipHop 🎻🎶"]="https://youtube.com/playlist?list=PLkrzfEDjeYJnmgMYwCKid4XIFqUKBVWEs&si=vahW_noh4UDJ5d37"
  ["Top Youtube Music 2023 ☕️🎶"]="https://youtube.com/playlist?list=PLDIoUOhQQPlXr63I_vwF9GD8sAKh77dWU&si=y7qNeEVFNgA-XxKy"
  ["Wish 107.5 YT Wishclusives ☕️🎶"]="https://youtube.com/playlist?list=PLkrzfEDjeYJn5B22H9HOWP3Kxxs-DkPSM&si=d_Ld2OKhGvpH48WO"
  ["Chillhop ☕️🎶"]="http://stream.zeno.fm/fyn8eh3h5f8uv"
  ["SmoothChill ☕️🎶"]="https://media-ssl.musicradio.com/SmoothChill"
  ["Relaxing Music ☕️🎶"]="https://youtube.com/playlist?list=PLMIbmfP_9vb8BCxRoraJpoo4q1yMFg4CE"
  ["Youtube Remix 📻🎶"]="https://youtube.com/playlist?list=PLeqTkIUlrZXlSNn3tcXAa-zbo95j0iN-0"
  ["Korean Drama OST 📻🎶"]="https://youtube.com/playlist?list=PLUge_o9AIFp4HuA-A3e3ZqENh63LuRRlQ"
)


# Populate local_music array with files from music directory and subdirectories
populate_local_music() {
  local_music=()
  filenames=()
  while IFS= read -r file; do
    local_music+=("$file")
    filenames+=("$(basename "$file")")
  done < <(find "$mDIR" -type f \( -iname "*.mp3" -o -iname "*.flac" -o -iname "*.wav" -o -iname "*.ogg" -o -iname "*.mp4" \))
}

# Function for displaying notifications
notification() {
  notify-send -u normal -i "$iDIR/music.png" "Playing: $@"
}

# Main function for playing local music
play_local_music() {
  populate_local_music

  # Prompt the user to select a song
  choice=$(printf "%s\n" "${filenames[@]}" | rofi -i -dmenu -config ~/.config/rofi/config-rofi-Beats.rasi -p "Local Music")

  if [ -z "$choice" ]; then
    exit 1
  fi

  # Find the corresponding file path based on user's choice and set that to play the song then continue on the list
  for (( i=0; i<"${#filenames[@]}"; ++i )); do
    if [ "${filenames[$i]}" = "$choice" ]; then
      notification "$choice"

      # For some reason wont start playlist at 0
      if [[ $i -eq 0 ]]; then
        # Play the selected local music file using mpv
        mpv --loop-playlist --vid=no "$mDIR/$choice"
      else
        file=$i
        # Play the selected local music file using mpv
        mpv --playlist-start="$file" --loop-playlist --vid=no "$mDIR/$choice"
      fi
      break
    fi
  done
}

# Main function for shuffling local music
shuffle_local_music() {
  notification "Shuffle local music"

  # Play music in $mDIR on shuffle
  mpv --shuffle --loop-playlist --vid=no "$mDIR"
}

# Main function for playing online music
play_online_music() {
  choice=$(printf "%s\n" "${!online_music[@]}" | rofi -i -dmenu -config ~/.config/rofi/config-rofi-Beats.rasi -p "Online Music")

  if [ -z "$choice" ]; then
    exit 1
  fi

  link="${online_music[$choice]}"

  notification "$choice"
  
  # Play the selected online music using mpv
  mpv --shuffle --vid=no "$link"
}

# Main function for playing Quran recitations
play_quran_recitations() {
  choice=$(printf "%s\n" "${!quran_recitations[@]}" | rofi -i -dmenu -config ~/.config/rofi/config-rofi-Beats.rasi -p "Quran Recitations")

  if [ -z "$choice" ]; then
    exit 1
  fi

  link="${quran_recitations[$choice]}"

  notification "$choice"
  
  # Play the selected Quran recitation using mpv
  mpv --shuffle --vid=no "$link"
}

# Check if an online music process is running and send a notification, otherwise run the main function
pkill mpv && notify-send -u low -i "$iDIR/music.png" "Music stopped" || {

# Prompt the user to choose between local music, online music, and Quran recitations
user_choice=$(printf "Play Quran Recitations\nPlay from Online Stations\nPlay from Music Folder\nShuffle Play from Music Folder" | rofi -dmenu -config ~/.config/rofi/config-rofi-Beats-menu.rasi -p "Select music source")

  case "$user_choice" in
    "Play Quran Recitations")
      play_quran_recitations
      ;;
    "Play from Music Folder")
      play_local_music
      ;;
    "Play from Online Stations")
      play_online_music
      ;;
    "Shuffle Play from Music Folder")
      shuffle_local_music
      ;;
    *)
      echo "Invalid choice"
      ;;
  esac
}

