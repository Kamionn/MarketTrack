IDENTIFICATION DIVISION.
       PROGRAM-ID. GestionInventaire.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT produit-fichier ASSIGN TO "produits.dat"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD produit-fichier.
       01 produit-record.
           05 produit-code            PIC X(10).
           05 produit-nom             PIC X(30).
           05 produit-categorie       PIC X(15).
           05 produit-quantite        PIC 9(5).
           05 produit-prix-unitaire   PIC 9(5)V99.

       WORKING-STORAGE SECTION.
       77 choix-utilisateur       PIC 9 VALUE 0.
       77 recherche-code          PIC X(10).
       77 recherche-nom           PIC X(30).
       77 quantite-vendue         PIC 9(5).
       77 total-vente             PIC 9(7)V99 VALUE 0.
       77 seuil-reapprovisionnement PIC 9(5) VALUE 10.
       77 confirmation            PIC X(1).
       01 produit-temporaire.
           05 temp-code            PIC X(10).
           05 temp-nom             PIC X(30).
           05 temp-categorie       PIC X(15).
           05 temp-quantite        PIC 9(5).
           05 temp-prix-unitaire   PIC 9(5)V99.

       PROCEDURE DIVISION.
       DEBUT.
           PERFORM OUVRIR-FICHIER
           PERFORM MENU-PRINCIPAL
           PERFORM FERMER-FICHIER
           STOP RUN.

       MENU-PRINCIPAL.
           DISPLAY "1. Ajouter un produit".
           DISPLAY "2. Mettre à jour un produit".
           DISPLAY "3. Supprimer un produit".
           DISPLAY "4. Enregistrer une vente".
           DISPLAY "5. Générer un rapport d'inventaire".
           DISPLAY "6. Rechercher un produit par nom".
           DISPLAY "7. Quitter".
           ACCEPT choix-utilisateur.
           EVALUATE choix-utilisateur
               WHEN 1
                   PERFORM AJOUTER-PRODUIT
                   PERFORM MENU-PRINCIPAL
               WHEN 2
                   PERFORM METTRE-A-JOUR-PRODUIT
                   PERFORM MENU-PRINCIPAL
               WHEN 3
                   PERFORM SUPPRIMER-PRODUIT
                   PERFORM MENU-PRINCIPAL
               WHEN 4
                   PERFORM ENREGISTRER-VENTE
                   PERFORM MENU-PRINCIPAL
               WHEN 5
                   PERFORM GENERER-RAPPORT
                   PERFORM MENU-PRINCIPAL
               WHEN 6
                   PERFORM RECHERCHER-PRODUIT-NOM
                   PERFORM MENU-PRINCIPAL
               WHEN 7
                   EXIT PROGRAM
               WHEN OTHER
                   DISPLAY "Choix invalide, essayez à nouveau."
                   PERFORM MENU-PRINCIPAL
           END-EVALUATE.

       AJOUTER-PRODUIT.
           DISPLAY "Entrez le code du produit : ".
           ACCEPT produit-code.
           DISPLAY "Entrez le nom du produit : ".
           ACCEPT produit-nom.
           DISPLAY "Entrez la catégorie du produit : ".
           ACCEPT produit-categorie.
           DISPLAY "Entrez la quantité en stock (nombre) : ".
           ACCEPT produit-quantite.
           IF produit-quantite NUMERIC
               DISPLAY "Entrez le prix unitaire (ex : 100.50) : ".
               ACCEPT produit-prix-unitaire
               IF produit-prix-unitaire NUMERIC
                   WRITE produit-record.
                   DISPLAY "Produit ajouté avec succès !"
               ELSE
                   DISPLAY "Erreur : Le prix unitaire doit être un nombre."
                   PERFORM AJOUTER-PRODUIT
               END-IF
           ELSE
               DISPLAY "Erreur : La quantité doit être un nombre."
               PERFORM AJOUTER-PRODUIT
           END-IF.

       METTRE-A-JOUR-PRODUIT.
           DISPLAY "Entrez le code du produit à mettre à jour : ".
           ACCEPT recherche-code.
           PERFORM RECHERCHER-PRODUIT.
           IF temp-code = recherche-code
               DISPLAY "Produit trouvé : " temp-nom.
               DISPLAY "Entrez le nouveau nom du produit : ".
               ACCEPT temp-nom.
               DISPLAY "Entrez la nouvelle catégorie : ".
               ACCEPT temp-categorie.
               DISPLAY "Entrez la nouvelle quantité : ".
               ACCEPT temp-quantite.
               DISPLAY "Entrez le nouveau prix unitaire : ".
               ACCEPT temp-prix-unitaire.
               REWRITE produit-record FROM produit-temporaire.
               DISPLAY "Produit mis à jour avec succès !"
           ELSE
               DISPLAY "Produit non trouvé."
           END-IF.

       SUPPRIMER-PRODUIT.
           DISPLAY "Entrez le code du produit à supprimer : ".
           ACCEPT recherche-code.
           PERFORM RECHERCHER-PRODUIT.
           IF temp-code = recherche-code
               DISPLAY "Produit trouvé : " temp-nom.
               DISPLAY "Confirmez la suppression (O/N) : ".
               ACCEPT confirmation.
               IF confirmation = "O"
                   DELETE produit-fichier.
                   DISPLAY "Produit supprimé avec succès."
               ELSE
                   DISPLAY "Suppression annulée."
               END-IF
           ELSE
               DISPLAY "Produit non trouvé."
           END-IF.

       ENREGISTRER-VENTE.
           DISPLAY "Entrez le code du produit vendu : ".
           ACCEPT recherche-code.
           PERFORM RECHERCHER-PRODUIT.
           IF temp-code = recherche-code
               DISPLAY "Entrez la quantité vendue : ".
               ACCEPT quantite-vendue
               IF temp-quantite >= quantite-vendue
                   COMPUTE temp-quantite = temp-quantite - quantite-vendue
                   COMPUTE total-vente = quantite-vendue * temp-prix-unitaire
                   REWRITE produit-record FROM produit-temporaire
                   DISPLAY "Vente enregistrée, total : " total-vente
               ELSE
                   DISPLAY "Quantité insuffisante en stock."
               END-IF
           ELSE
               DISPLAY "Produit non trouvé."
           END-IF.

       RECHERCHER-PRODUIT.
           OPEN INPUT produit-fichier.
           PERFORM UNTIL produit-code = recherche-code OR AT END
               READ produit-fichier INTO produit-temporaire
                   AT END
                       DISPLAY "Produit non trouvé."
                       EXIT PERFORM
           END-PERFORM.
           CLOSE produit-fichier.

       RECHERCHER-PRODUIT-NOM.
           DISPLAY "Entrez le nom du produit à rechercher : ".
           ACCEPT recherche-nom.
           OPEN INPUT produit-fichier.
           PERFORM UNTIL AT END
               READ produit-fichier INTO produit-temporaire
                   AT END
                       DISPLAY "Fin de la recherche."
                       EXIT PERFORM
               IF temp-nom = recherche-nom
                   DISPLAY "Produit trouvé : " temp-nom ", Code : " temp-code
               END-IF
           END-PERFORM.
           CLOSE produit-fichier.

       GENERER-RAPPORT.
           DISPLAY "Rapport d'inventaire :".
           OPEN INPUT produit-fichier.
           PERFORM UNTIL AT END
               READ produit-fichier INTO produit-temporaire
                   AT END
                       EXIT PERFORM
               IF temp-quantite < seuil-reapprovisionnement
                   DISPLAY "Produit : " temp-nom ", Code : " temp-code ", Quantité : " temp-quantite
               END-IF
           END-PERFORM.
           CLOSE produit-fichier.

       OUVRIR-FICHIER.
           OPEN I-O produit-fichier.
           IF NOT EXISTS
               DISPLAY "Le fichier de produit n'existe pas, création du fichier..."
               OPEN OUTPUT produit-fichier
               CLOSE produit-fichier
               OPEN I-O produit-fichier
           END-IF.

       FERMER-FICHIER.
           CLOSE produit-fichier.
