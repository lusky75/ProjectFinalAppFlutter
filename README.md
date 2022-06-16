# ProjectFinalAppFlutter

Au lancement du projet, la page main contient un login et un register.
S'il y a une erreur, affiche une popup: description de l'erreur.

Lorsque l'utilisateur se connecte, il accède à la page Home, à sa gauche il y a:
Un menu permettant modifier sa photo de profil, ajouter son pseudo, et d'afficher son nom et prénom.
Le menu peut naviguer vers les pages:
- Home (affichant toutes les annonces des utilisateurs ) 
  L'utilisateur peut consulter les annonces dans l'ordre du plus récent ou du moins récent par un filtre
  Mettre en favori ou bien enlever de ses favoris une annonce (si le favori existe déjà sur Firebase alors ne fait rien)

- Mes annonces (affichant toutes les annonces de l'utilisateur connecté):

  L'utilisateur pourra créer une annonce et mettre à jour une annonce sélectionnée: 
  Navigue vers une nouvelle page contenant 3 champs (title, description et price)
  Si les champs sont vides ou si le champ price n'est pas numérique (affiche une popup d'erreur suivi d'un message)
  Pour supprimer une annonce, il suffit de balayer l'annonce sélectionnée de la droite vers la gauche.

- Mes favoris (affichant toutes les annonces que l'utilisateur a mis en favoris)

- Mon profil pour afficher les données de l'utilisateur
  L'utilisateur peut modifier son profil

- Bouton Settings (rien pour l'instant)
- Bouton Logout (mets à vide l'utilisateur et navigue vers la page de Login --> MyApp)


