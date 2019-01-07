# EjectAll

Eject all mounted Mac OS X disk images at once.

![Full-width icon](icon/EjectAll3%20-%20512.png)
![Finder action bar icon](icon/EjectAll3%20-%2032.png)
![Small icon](icon/EjectAll2%20-%2016.png)

## Usage

The main use case is to clean up mounted disk images after a session of installing software on Mac OS X.

- When launched, this app will eject all mounted disk images.
- If launched again another time within 20 seconds, it will also eject all mounted physical drives.
- If launched a third time within 20 seconds, it will display a dialog to select drives to force eject.

The recommended setup is to add this app in the Finder windows toolbar, to replace the native “eject” button. The icon is made to fit properly in there.

![Icon in the action bar](Manuel.rtfd/EjectAll%20in%20toolbar.jpg)

## Manual (in French)

EjectAll est un utilitaire permettant d'éjecter toutes les images disques montées sur un système, voire tous les médias éjectables.

- pour éjecter les images disque, cliquez une fois sur l'icône
- pour éjecter tous les médias éjectable (disques durs, CD…), cliquez à nouveau sur l'icône
- pour forcer l'éjection d'un média récalcitrant, cliquez encore une fois

Il est pratique de faire apparaître EjectAll dans la barre d'outils du Finder, pour l'avoir en permanence à portée.
Pour cela, faites glisser l'icône d'EjectAll sur la barre d'outils, et laissez-y là quelques instants.
Pour supprimer ce raccourci, glisser l'icône en appuyant sur la touche  du clavier.

### Nouveautés de la version 3

- ajout de la fonctionnalité de forçage d'éjection
- accélération du processus
- autorise l'éjection de DMGs de même noms (autrefois, seule la première montée était éjectée)

### Problèmes connus

- les images disques contenant une apostrophe ne sont pas éjectées au premier clic

## Deprecation notice

This was super useful before the App Store came along. Installing software through disk images is now less common and this script doesn't have much of a use case anymore. The “force eject” feature introduced in v3 was added to core Mac OS X in Sierra.

## License

MIT
