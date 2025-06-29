🐸 Frogs Weather V2

Frogs Weather est une application Flutter de météo dynamique, simple, fluide et élégante, qui utilise l'API OpenWeatherMap pour afficher la météo actuelle dans une ville donnée ou en utilisant votre localisation automatiquement.
📱 Aperçu

    🌍 Localisation automatique

    🏩 Recherche de ville manuelle

    ☄️ Image de fond dynamique selon le type de météo (ensoleillé, pluie, neige, etc.)

    🌡️ Détails météo : température, humidité, vent, pression, pluie...

    🇫🇷 Interface en français

🛠️ Technologies

    Flutter

    OpenWeatherMap API

    font_awesome_flutter

    geolocator

    logger

🛆 Installation

    Cloner le dépôt :

git clone https://github.com/Kevin-642/frogs_weather_v2.git
cd frogs_weather_v2

Installer les dépendances :

flutter pub get

Lancer l'application :

Sur un appareil Android ou iOS connecté :

    flutter run

⚙️ Configuration
Clé API

L'application utilise l'API OpenWeatherMap. Pour fonctionner, vous devez obtenir une clé gratuite :

    Créez un compte sur https://openweathermap.org/api

    Récupérez votre clé API

    Créez un fichier lib/constants/api_keys.dart (ou modifiez-le s'il existe) et ajoutez-y :

    const String openWeatherApiKey = 'VOTRE_API_KEY_ICI';

🖼️ Images de fond dynamiques

Les images sont stockées dans le dossier assets/images/ :

    sunny.jpg

    cloudy.jpg

    rainy.jpg

    stormy.jpg

    snowy.jpg

    mist.jpg

    default.jpg

Elles sont automatiquement sélectionnées selon le type de météo retourné par l'API.
🔒 Permissions

Cette app utilise la localisation :

    Android : vérifier que AndroidManifest.xml contient :

<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />

iOS : ajouter dans Info.plist :

    <key>NSLocationWhenInUseUsageDescription</key>
    <string>Nous avons besoin de votre localisation pour afficher la météo locale</string>

📄 Licence

Ce projet est open-source, sous licence MIT. Vous pouvez l’utiliser, le modifier et le redistribuer librement.
🐸 Auteur

Développé avec ❤️ par Kevin

📢 https://github.com/Kevin-642
https://www.linkedin.com/in/kevin-p-817aa5301/

Dernière mise à jour : 2025-06-29