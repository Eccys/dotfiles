# Made by Ecys — https://ecys.xyz

#!/bin/bash
# For Rofi Beats to play online Music or Locally save media files

# Directory local music folder
mDIR="$HOME/Music/"

# Directory for icons
iDIR="$HOME/.config/swaync/icons"

# Quran recitations
declare -A mishary=(
  ["1. Surat Al-Fatihah 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/001.mp3"
  ["2. Surat Al-Baqarah 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/002.mp3"
  ["3. Surat Ali'Imran 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/003.mp3"
  ["4. Surat Al-Nisa 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/004.mp3"
  ["5. Surat Al-Ma'idah 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/005.mp3"
  ["6. Surat Al-An'am 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/006.mp3"
  ["7. Surat Al-A'raf 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/007.mp3"
  ["8. Surat Al-Anfal 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/008.mp3"
  ["9. Surat At-Tawbah 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/009.mp3"
  ["10. Surat Yunus 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/010.mp3"
  ["11. Surat Hud 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/011.mp3"
  ["12. Surat Yusuf 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/012.mp3"
  ["13. Surat Ar-Ra'd 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/013.mp3"
  ["14. Surat Ibrahim 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/014.mp3"
  ["15. Surat Al-Hijr 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/015.mp3"
  ["16. Surat An-Nahl 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/016.mp3"
  ["17. Surat Al-Isra 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/017.mp3"
  ["18. Surat Al-Kahf 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/018.mp3"
  ["19. Surat Maryam 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/019.mp3"
  ["20. Surat Ta-Ha 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/020.mp3"
  ["21. Surat Al-Anbiya 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/021.mp3"
  ["22. Surat Al-Hajj 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/022.mp3"
  ["23. Surat Al-Mu'minun 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/023.mp3"
  ["24. Surat An-Nur 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/024.mp3"
  ["25. Surat Al-Furqan 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/025.mp3"
  ["26. Surat Ash-Shu'ara 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/026.mp3"
  ["27. Surat An-Naml 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/027.mp3"
  ["28. Surat Al-Qasas 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/028.mp3"
  ["29. Surat Al-Ankabut 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/029.mp3"
  ["30. Surat Ar-Rum 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/030.mp3"
  ["31. Surat Luqman 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/031.mp3"
  ["32. Surat As-Sajda 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/032.mp3"
  ["33. Surat Al-Ahzab 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/033.mp3"
  ["34. Surat Saba 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/034.mp3"
  ["35. Surat Fatir 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/035.mp3"
  ["36. Surat Ya-Sin 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/036.mp3"
  ["37. Surat As-Saffat 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/037.mp3"
  ["38. Surat Sad 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/038.mp3"
  ["39. Surat Az-Zumar 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/039.mp3"
  ["40. Surat Ghafir 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/040.mp3"
  ["41. Surat Fussilat 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/041.mp3"
  ["42. Surat Ash-Shura 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/042.mp3"
  ["43. Surat Az-Zukhruf 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/043.mp3"
  ["44. Surat Ad-Dukhan 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/044.mp3"
  ["45. Surat Al-Jathiya 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/045.mp3"
  ["46. Surat Al-Ahqaf 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/046.mp3"
  ["47. Surat Muhammad 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/047.mp3"
  ["48. Surat Al-Fath 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/048.mp3"
  ["49. Surat Al-Hujurat 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/049.mp3"
  ["50. Surat Qaf 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/050.mp3"
  ["51. Surat Adh-Dhariyat 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/051.mp3"
  ["52. Surat At-Tur 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/052.mp3"
  ["53. Surat An-Najm 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/053.mp3"
  ["54. Surat Al-Qamar 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/054.mp3"
  ["55. Surat Ar-Rahman 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/055.mp3"
  ["56. Surat Al-Waqia 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/056.mp3"
  ["57. Surat Al-Hadid 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/057.mp3"
  ["58. Surat Al-Mujadila 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/058.mp3"
  ["59. Surat Al-Hashr 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/059.mp3"
  ["60. Surat Al-Mumtahina 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/060.mp3"
  ["61. Surat As-Saff 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/061.mp3"
  ["62. Surat Al-Jumu'a 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/062.mp3"
  ["63. Surat Al-Munafiqun 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/063.mp3"
  ["64. Surat At-Taghabun 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/064.mp3"
  ["65. Surat At-Talaq 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/065.mp3"
  ["66. Surat At-Tahrim 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/066.mp3"
  ["67. Surat Al-Mulk 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/067.mp3"
  ["68. Surat Al-Qalam 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/068.mp3"
  ["69. Surat Al-Haqqah 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/069.mp3"
  ["70. Surat Al-Ma'arij 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/070.mp3"
  ["71. Surat Nuh 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/071.mp3"
  ["72. Surat Al-Jinn 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/072.mp3"
  ["73. Surat Al-Muzzammil 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/073.mp3"
  ["74. Surat Al-Muddathir 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/074.mp3"
  ["75. Surat Al-Qiyama 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/075.mp3"
  ["76. Surat Al-Insan 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/076.mp3"
  ["77. Surat Al-Mursalat 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/077.mp3"
  ["78. Surat An-Naba 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/078.mp3"
  ["79. Surat An-Naziat 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/079.mp3"
  ["80. Surat Abasa 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/080.mp3"
  ["81. Surat At-Takwir 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/081.mp3"
  ["82. Surat Al-Infitar 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/082.mp3"
  ["83. Surat Al-Mutaffifin 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/083.mp3"
  ["84. Surat Al-Inshiqaq 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/084.mp3"
  ["85. Surat Al-Buruj 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/085.mp3"
  ["86. Surat At-Tariq 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/086.mp3"
  ["87. Surat Al-Ala 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/087.mp3"
  ["88. Surat Al-Ghashiya 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/088.mp3"
  ["89. Surat Al-Fajr 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/089.mp3"
  ["90. Surat Al-Balad 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/090.mp3"
  ["91. Surat Ash-Shams 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/091.mp3"
  ["92. Surat Al-Layl 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/092.mp3"
  ["93. Surat Ad-Duha 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/093.mp3"
  ["94. Surat Ash-Sharh 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/094.mp3"
  ["95. Surat At-Tin 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/095.mp3"
  ["96. Surat Al-Alaq 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/096.mp3"
  ["97. Surat Al-Qadr 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/097.mp3"
  ["98. Surat Al-Bayyina 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/098.mp3"
  ["99. Surat Az-Zalzala 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/099.mp3"
  ["100. Surat Al-Adiyat 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/100.mp3"
  ["101. Surat Al-Qaria 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/101.mp3"
  ["102. Surat At-Takathur 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/102.mp3"
  ["103. Surat Al-Asr 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/103.mp3"
  ["104. Surat Al-Humaza 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/104.mp3"
  ["105. Surat Al-Fil 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/105.mp3"
  ["106. Surat Quraysh 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/106.mp3"
  ["107. Surat Al-Ma'un 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/107.mp3"
  ["108. Surat Al-Kawthar 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/108.mp3"
  ["109. Surat Al-Kafirun 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/109.mp3"
  ["110. Surat An-Nasr 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/110.mp3"
  ["111. Surat Al-Masad 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/111.mp3"
  ["112. Surat Al-Ikhlas 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/112.mp3"
  ["113. Surat Al-Falaq 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/113.mp3"
  ["114. Surat An-Nas 🎙️"]="https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/114.mp3"
)

declare -A fares=(
  ["1. Surat Al-Fatihah 🎙️"]="https://download.quranicaudio.com/quran/fares/001.mp3"
  ["2. Surat Al-Baqarah 🎙️"]="https://download.quranicaudio.com/quran/fares/002.mp3"
  ["3. Surat Ali'Imran 🎙️"]="https://download.quranicaudio.com/quran/fares/003.mp3"
  ["4. Surat Al-Nisa 🎙️"]="https://download.quranicaudio.com/quran/fares/004.mp3"
  ["5. Surat Al-Ma'idah 🎙️"]="https://download.quranicaudio.com/quran/fares/005.mp3"
  ["6. Surat Al-An'am 🎙️"]="https://download.quranicaudio.com/quran/fares/006.mp3"
  ["7. Surat Al-A'raf 🎙️"]="https://download.quranicaudio.com/quran/fares/007.mp3"
  ["8. Surat Al-Anfal 🎙️"]="https://download.quranicaudio.com/quran/fares/008.mp3"
  ["9. Surat At-Tawbah 🎙️"]="https://download.quranicaudio.com/quran/fares/009.mp3"
  ["10. Surat Yunus 🎙️"]="https://download.quranicaudio.com/quran/fares/010.mp3"
  ["11. Surat Hud 🎙️"]="https://download.quranicaudio.com/quran/fares/011.mp3"
  ["12. Surat Yusuf 🎙️"]="https://download.quranicaudio.com/quran/fares/012.mp3"
  ["13. Surat Ar-Ra'd 🎙️"]="https://download.quranicaudio.com/quran/fares/013.mp3"
  ["14. Surat Ibrahim 🎙️"]="https://download.quranicaudio.com/quran/fares/014.mp3"
  ["15. Surat Al-Hijr 🎙️"]="https://download.quranicaudio.com/quran/fares/015.mp3"
  ["16. Surat An-Nahl 🎙️"]="https://download.quranicaudio.com/quran/fares/016.mp3"
  ["17. Surat Al-Isra 🎙️"]="https://download.quranicaudio.com/quran/fares/017.mp3"
  ["18. Surat Al-Kahf 🎙️"]="https://download.quranicaudio.com/quran/fares/018.mp3"
  ["19. Surat Maryam 🎙️"]="https://download.quranicaudio.com/quran/fares/019.mp3"
  ["20. Surat Ta-Ha 🎙️"]="https://download.quranicaudio.com/quran/fares/020.mp3"
  ["21. Surat Al-Anbiya 🎙️"]="https://download.quranicaudio.com/quran/fares/021.mp3"
  ["22. Surat Al-Hajj 🎙️"]="https://download.quranicaudio.com/quran/fares/022.mp3"
  ["23. Surat Al-Mu'minun 🎙️"]="https://download.quranicaudio.com/quran/fares/023.mp3"
  ["24. Surat An-Nur 🎙️"]="https://download.quranicaudio.com/quran/fares/024.mp3"
  ["25. Surat Al-Furqan 🎙️"]="https://download.quranicaudio.com/quran/fares/025.mp3"
  ["26. Surat Ash-Shu'ara 🎙️"]="https://download.quranicaudio.com/quran/fares/026.mp3"
  ["27. Surat An-Naml 🎙️"]="https://download.quranicaudio.com/quran/fares/027.mp3"
  ["28. Surat Al-Qasas 🎙️"]="https://download.quranicaudio.com/quran/fares/028.mp3"
  ["29. Surat Al-Ankabut 🎙️"]="https://download.quranicaudio.com/quran/fares/029.mp3"
  ["30. Surat Ar-Rum 🎙️"]="https://download.quranicaudio.com/quran/fares/030.mp3"
  ["31. Surat Luqman 🎙️"]="https://download.quranicaudio.com/quran/fares/031.mp3"
  ["32. Surat As-Sajda 🎙️"]="https://download.quranicaudio.com/quran/fares/032.mp3"
  ["33. Surat Al-Ahzab 🎙️"]="https://download.quranicaudio.com/quran/fares/033.mp3"
  ["34. Surat Saba 🎙️"]="https://download.quranicaudio.com/quran/fares/034.mp3"
  ["35. Surat Fatir 🎙️"]="https://download.quranicaudio.com/quran/fares/035.mp3"
  ["36. Surat Ya-Sin 🎙️"]="https://download.quranicaudio.com/quran/fares/036.mp3"
  ["37. Surat As-Saffat 🎙️"]="https://download.quranicaudio.com/quran/fares/037.mp3"
  ["38. Surat Sad 🎙️"]="https://download.quranicaudio.com/quran/fares/038.mp3"
  ["39. Surat Az-Zumar 🎙️"]="https://download.quranicaudio.com/quran/fares/039.mp3"
  ["40. Surat Ghafir 🎙️"]="https://download.quranicaudio.com/quran/fares/040.mp3"
  ["41. Surat Fussilat 🎙️"]="https://download.quranicaudio.com/quran/fares/041.mp3"
  ["42. Surat Ash-Shura 🎙️"]="https://download.quranicaudio.com/quran/fares/042.mp3"
  ["43. Surat Az-Zukhruf 🎙️"]="https://download.quranicaudio.com/quran/fares/043.mp3"
  ["44. Surat Ad-Dukhan 🎙️"]="https://download.quranicaudio.com/quran/fares/044.mp3"
  ["45. Surat Al-Jathiya 🎙️"]="https://download.quranicaudio.com/quran/fares/045.mp3"
  ["46. Surat Al-Ahqaf 🎙️"]="https://download.quranicaudio.com/quran/fares/046.mp3"
  ["47. Surat Muhammad 🎙️"]="https://download.quranicaudio.com/quran/fares/047.mp3"
  ["48. Surat Al-Fath 🎙️"]="https://download.quranicaudio.com/quran/fares/048.mp3"
  ["49. Surat Al-Hujurat 🎙️"]="https://download.quranicaudio.com/quran/fares/049.mp3"
  ["50. Surat Qaf 🎙️"]="https://download.quranicaudio.com/quran/fares/050.mp3"
  ["51. Surat Adh-Dhariyat 🎙️"]="https://download.quranicaudio.com/quran/fares/051.mp3"
  ["52. Surat At-Tur 🎙️"]="https://download.quranicaudio.com/quran/fares/052.mp3"
  ["53. Surat An-Najm 🎙️"]="https://download.quranicaudio.com/quran/fares/053.mp3"
  ["54. Surat Al-Qamar 🎙️"]="https://download.quranicaudio.com/quran/fares/054.mp3"
  ["55. Surat Ar-Rahman 🎙️"]="https://download.quranicaudio.com/quran/fares/055.mp3"
  ["56. Surat Al-Waqia 🎙️"]="https://download.quranicaudio.com/quran/fares/056.mp3"
  ["57. Surat Al-Hadid 🎙️"]="https://download.quranicaudio.com/quran/fares/057.mp3"
  ["58. Surat Al-Mujadila 🎙️"]="https://download.quranicaudio.com/quran/fares/058.mp3"
  ["59. Surat Al-Hashr 🎙️"]="https://download.quranicaudio.com/quran/fares/059.mp3"
  ["60. Surat Al-Mumtahina 🎙️"]="https://download.quranicaudio.com/quran/fares/060.mp3"
  ["61. Surat As-Saff 🎙️"]="https://download.quranicaudio.com/quran/fares/061.mp3"
  ["62. Surat Al-Jumu'a 🎙️"]="https://download.quranicaudio.com/quran/fares/062.mp3"
  ["63. Surat Al-Munafiqun 🎙️"]="https://download.quranicaudio.com/quran/fares/063.mp3"
  ["64. Surat At-Taghabun 🎙️"]="https://download.quranicaudio.com/quran/fares/064.mp3"
  ["65. Surat At-Talaq 🎙️"]="https://download.quranicaudio.com/quran/fares/065.mp3"
  ["66. Surat At-Tahrim 🎙️"]="https://download.quranicaudio.com/quran/fares/066.mp3"
  ["67. Surat Al-Mulk 🎙️"]="https://download.quranicaudio.com/quran/fares/067.mp3"
  ["68. Surat Al-Qalam 🎙️"]="https://download.quranicaudio.com/quran/fares/068.mp3"
  ["69. Surat Al-Haqqah 🎙️"]="https://download.quranicaudio.com/quran/fares/069.mp3"
  ["70. Surat Al-Ma'arij 🎙️"]="https://download.quranicaudio.com/quran/fares/070.mp3"
  ["71. Surat Nuh 🎙️"]="https://download.quranicaudio.com/quran/fares/071.mp3"
  ["72. Surat Al-Jinn 🎙️"]="https://download.quranicaudio.com/quran/fares/072.mp3"
  ["73. Surat Al-Muzzammil 🎙️"]="https://download.quranicaudio.com/quran/fares/073.mp3"
  ["74. Surat Al-Muddathir 🎙️"]="https://download.quranicaudio.com/quran/fares/074.mp3"
  ["75. Surat Al-Qiyama 🎙️"]="https://download.quranicaudio.com/quran/fares/075.mp3"
  ["76. Surat Al-Insan 🎙️"]="https://download.quranicaudio.com/quran/fares/076.mp3"
  ["77. Surat Al-Mursalat 🎙️"]="https://download.quranicaudio.com/quran/fares/077.mp3"
  ["78. Surat An-Naba 🎙️"]="https://download.quranicaudio.com/quran/fares/078.mp3"
  ["79. Surat An-Naziat 🎙️"]="https://download.quranicaudio.com/quran/fares/079.mp3"
  ["80. Surat Abasa 🎙️"]="https://download.quranicaudio.com/quran/fares/080.mp3"
  ["81. Surat At-Takwir 🎙️"]="https://download.quranicaudio.com/quran/fares/081.mp3"
  ["82. Surat Al-Infitar 🎙️"]="https://download.quranicaudio.com/quran/fares/082.mp3"
  ["83. Surat Al-Mutaffifin 🎙️"]="https://download.quranicaudio.com/quran/fares/083.mp3"
  ["84. Surat Al-Inshiqaq 🎙️"]="https://download.quranicaudio.com/quran/fares/084.mp3"
  ["85. Surat Al-Buruj 🎙️"]="https://download.quranicaudio.com/quran/fares/085.mp3"
  ["86. Surat At-Tariq 🎙️"]="https://download.quranicaudio.com/quran/fares/086.mp3"
  ["87. Surat Al-Ala 🎙️"]="https://download.quranicaudio.com/quran/fares/087.mp3"
  ["88. Surat Al-Ghashiya 🎙️"]="https://download.quranicaudio.com/quran/fares/088.mp3"
  ["89. Surat Al-Fajr 🎙️"]="https://download.quranicaudio.com/quran/fares/089.mp3"
  ["90. Surat Al-Balad 🎙️"]="https://download.quranicaudio.com/quran/fares/090.mp3"
  ["91. Surat Ash-Shams 🎙️"]="https://download.quranicaudio.com/quran/fares/091.mp3"
  ["92. Surat Al-Layl 🎙️"]="https://download.quranicaudio.com/quran/fares/092.mp3"
  ["93. Surat Ad-Duha 🎙️"]="https://download.quranicaudio.com/quran/fares/093.mp3"
  ["94. Surat Ash-Sharh 🎙️"]="https://download.quranicaudio.com/quran/fares/094.mp3"
  ["95. Surat At-Tin 🎙️"]="https://download.quranicaudio.com/quran/fares/095.mp3"
  ["96. Surat Al-Alaq 🎙️"]="https://download.quranicaudio.com/quran/fares/096.mp3"
  ["97. Surat Al-Qadr 🎙️"]="https://download.quranicaudio.com/quran/fares/097.mp3"
  ["98. Surat Al-Bayyina 🎙️"]="https://download.quranicaudio.com/quran/fares/098.mp3"
  ["99. Surat Az-Zalzala 🎙️"]="https://download.quranicaudio.com/quran/fares/099.mp3"
  ["100. Surat Al-Adiyat 🎙️"]="https://download.quranicaudio.com/quran/fares/100.mp3"
  ["101. Surat Al-Qaria 🎙️"]="https://download.quranicaudio.com/quran/fares/101.mp3"
  ["102. Surat At-Takathur 🎙️"]="https://download.quranicaudio.com/quran/fares/102.mp3"
  ["103. Surat Al-Asr 🎙️"]="https://download.quranicaudio.com/quran/fares/103.mp3"
  ["104. Surat Al-Humaza 🎙️"]="https://download.quranicaudio.com/quran/fares/104.mp3"
  ["105. Surat Al-Fil 🎙️"]="https://download.quranicaudio.com/quran/fares/105.mp3"
  ["106. Surat Quraysh 🎙️"]="https://download.quranicaudio.com/quran/fares/106.mp3"
  ["107. Surat Al-Ma'un 🎙️"]="https://download.quranicaudio.com/quran/fares/107.mp3"
  ["108. Surat Al-Kawthar 🎙️"]="https://download.quranicaudio.com/quran/fares/108.mp3"
  ["109. Surat Al-Kafirun 🎙️"]="https://download.quranicaudio.com/quran/fares/109.mp3"
  ["110. Surat An-Nasr 🎙️"]="https://download.quranicaudio.com/quran/fares/110.mp3"
  ["111. Surat Al-Masad 🎙️"]="https://download.quranicaudio.com/quran/fares/111.mp3"
  ["112. Surat Al-Ikhlas 🎙️"]="https://download.quranicaudio.com/quran/fares/112.mp3"
  ["113. Surat Al-Falaq 🎙️"]="https://download.quranicaudio.com/quran/fares/113.mp3"
  ["114. Surat An-Nas 🎙️"]="https://download.quranicaudio.com/quran/fares/114.mp3"
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

# Main function for shuffling local music
shuffle_local_music() {
  populate_local_music

  if [ "${#local_music[@]}" -eq 0 ]; then
    notify-send -u normal -i "$iDIR/music.png" "Music directory is empty."
    exit 1
  fi

  notification "Shuffle Play"

  # Shuffle and play all local music files using mpv
  mpv --shuffle --loop-playlist --vid=no "${local_music[@]}"
}



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

# Main function for playing Mishary's recitations
play_mishary() {
  choice=$(printf "%s\n" "${!mishary[@]}" | rofi -i -dmenu -config ~/.config/rofi/config-rofi-Beats.rasi -p "Mishary's Recitations")

  if [ -z "$choice" ]; then
    exit 1
  fi

  link="${mishary[$choice]}"

  notification "$choice"
  
  # Play the selected Quran recitation using mpv
  mpv --shuffle --vid=no "$link"
}

# Main function for playing Fares's recitations
play_fares() {
  choice=$(printf "%s\n" "${!fares[@]}" | rofi -i -dmenu -config ~/.config/rofi/config-rofi-Beats.rasi -p "Fares's Recitations")

  if [ -z "$choice" ]; then
    exit 1
  fi

  link="${fares[$choice]}"

  notification "$choice"
  
  # Play the selected Quran recitation using mpv
  mpv --shuffle --vid=no "$link"
}

# Function to load the reciters menu
load_reciters() {
  reciter_choice=$(printf "Mishary\nFares" | rofi -dmenu -config ~/.config/rofi/config-rofi-Beats.rasi -p "Select Reciter")

  case "$reciter_choice" in
    "Mishary")
      play_mishary
      ;;
    "Fares")
      play_fares
      ;;
    *)
      echo "Invalid choice"
      ;;
  esac
}

# Main function for playing online music
play_online_music() {
  choice=$(printf "%s\n" "${!online_music[@]}" | rofi -i -dmenu -config ~/.config/rofi/config-rofi-Beats.rasi -p "Online Music Stations")

  if [ -z "$choice" ]; then
    exit 1
  fi

  link="${online_music[$choice]}"

  notification "$choice"
  
  # Play the selected online station using mpv
  mpv --no-video "$link"
}

# Check if an online music process is running and send a notification, otherwise run the main function
pkill mpv && notify-send -u low -i "$iDIR/music.png" "Music stopped" || {

# Prompt the user to choose between local music, online music, and Quran recitations
user_choice=$(printf "Play Quran Recitations\nPlay from Online Stations\nPlay from Music Folder\nShuffle Play from Music Folder" | rofi -dmenu -config ~/.config/rofi/config-rofi-Beats-menu.rasi -p "Select music source")

  case "$user_choice" in
    "Play Quran Recitations")
      load_reciters
      ;;
    "Play from Online Stations")
      play_online_music
      ;;
    "Play from Music Folder")
      play_local_music
      ;;
    "Shuffle Play from Music Folder")
      shuffle_local_music
      ;;
    *)
      echo "Invalid choice"
      ;;
  esac
}

