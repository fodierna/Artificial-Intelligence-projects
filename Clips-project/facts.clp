;DATABASE
(deftemplate hotel
  (slot name)
  (slot num-of-rooms)
  (slot num-of-available-rooms)
  (slot location)
  (slot stars (range 0 4))
  (slot cost))

(deftemplate location
  (slot name)
  (slot region)
  (slot x)
  (slot y)
  (multislot kind-of-tourism-and-stars)
  (multislot hotels))

(deftemplate region
  (slot name)
  (multislot locations))


(deftemplate attribute
   (slot name)
   (multislot value)
   (slot certainty (default 100.0)))

(deftemplate question
  (slot attribute (default ?NONE))
  (slot the-question (default ?NONE))
  (multislot valid-answers (default ?NONE))
  (slot already-asked (default FALSE))
  (multislot precursors (default ?DERIVE)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(deffacts definition-of-regions
  (region (name Toscana) (locations Siena Arezzo Grosseto Firenze))
  (region (name Lazio) (locations Roma Ostia Bolsena))
  (region (name Umbria) (locations Terni Assisi Perugia))
  (region (name Campania) (locations Napoli Avellino Salerno Benevento)))

(deffacts definition-of-hotels
  (hotel (name Diamante) (num-of-rooms 10) (num-of-available-rooms 4) (location Firenze) (stars 4) (cost 125))
  (hotel (name Rubino) (num-of-rooms 8) (num-of-available-rooms 1) (location Terni) (stars 3) (cost 100))
  (hotel (name Topazio) (num-of-rooms 2) (num-of-available-rooms 0) (location Roma) (stars 2) (cost 75))
  (hotel (name Vetro) (num-of-rooms 20) (num-of-available-rooms 15) (location Assisi) (stars 1) (cost 50))

  (hotel (name Platino) (num-of-rooms 15) (num-of-available-rooms 15) (location Roma) (stars 4) (cost 125))
  (hotel (name Oro) (num-of-rooms 10) (num-of-available-rooms 8) (location Arezzo) (stars 3) (cost 100))
  (hotel (name Acciaio) (num-of-rooms 30) (num-of-available-rooms 28) (location Siena) (stars 2) (cost 75))
  (hotel (name Ferro) (num-of-rooms 5) (num-of-available-rooms 1) (location Terni) (stars 1) (cost 50))

  (hotel (name Quattrocento) (num-of-rooms 40) (num-of-available-rooms 25) (location Siena) (stars 4) (cost 125))
  (hotel (name Trecento) (num-of-rooms 30) (num-of-available-rooms 10) (location Bolsena) (stars 3) (cost 100))
  (hotel (name Duecento) (num-of-rooms 20) (num-of-available-rooms 10) (location Perugia) (stars 2) (cost 75))
  (hotel (name Cento) (num-of-rooms 10) (num-of-available-rooms 3) (location Arezzo) (stars 1) (cost 50))

  (hotel (name Menabrea) (num-of-rooms 15) (num-of-available-rooms 13) (location Perugia) (stars 4) (cost 125))
  (hotel (name Peroni) (num-of-rooms 4) (num-of-available-rooms 2) (location Ostia) (stars 3) (cost 100))
  (hotel (name Moretti) (num-of-rooms 20) (num-of-available-rooms 12) (location Grosseto) (stars 2) (cost 75))
  (hotel (name Poretti) (num-of-rooms 10) (num-of-available-rooms 9) (location Bolsena) (stars 1) (cost 50))

  (hotel (name Lupin) (num-of-rooms 50) (num-of-available-rooms 34) (location Grosseto) (stars 4) (cost 125))
  (hotel (name Fujiko) (num-of-rooms 32) (num-of-available-rooms 30) (location Firenze) (stars 3) (cost 100))
  (hotel (name Goemon) (num-of-rooms 13) (num-of-available-rooms 7) (location Roma) (stars 2) (cost 75))
  (hotel (name Jigen) (num-of-rooms 22) (num-of-available-rooms 1) (location Ostia) (stars 1) (cost 50))

  (hotel (name Timon) (num-of-rooms 15) (num-of-available-rooms 11) (location Napoli) (stars 4) (cost 125))
  (hotel (name Pumba) (num-of-rooms 20) (num-of-available-rooms 12) (location Salerno) (stars 3) (cost 100))
  (hotel (name Simba) (num-of-rooms 20) (num-of-available-rooms 7) (location Avellino) (stars 2) (cost 75))
  (hotel (name Nala) (num-of-rooms 22) (num-of-available-rooms 1) (location Benevento) (stars 1) (cost 50)))

(deffacts definition-of-locations
  (location (name Ostia)
    (region Lazio)
    (x 0)
    (y 0)
    (kind-of-tourism-and-stars naturalistico 2 balneare 5)
    (hotels Peroni Jigen)
  )

  (location (name Bolsena)
    (region Lazio)
    (x 0)
    (y 5)
    (kind-of-tourism-and-stars naturalistico 4 lacustre 5)
    (hotels Trecento Poretti)
  )

  (location (name Roma)
    (region Lazio)
    (x 2)
    (y 0)
    (kind-of-tourism-and-stars culturale 5 religioso 5 sportivo 4 termale 3 enogastronomico 3)
    (hotels Topazio Platino Goemon)
  )

  (location (name Terni)
    (region Umbria)
    (x 3)
    (y 5)
    (kind-of-tourism-and-stars naturalistico 2 montano 4 lacustre 3)
    (hotels Rubino Ferro)
  )

  (location (name Assisi)
    (region Umbria)
    (x 4)
    (y 6)
    (kind-of-tourism-and-stars religioso 5 naturalistico 2 montano 3)
    (hotels Vetro)
  )

  (location (name Perugia)
    (region Umbria)
    (x 3)
    (y 7)
    (kind-of-tourism-and-stars culturale 3 religioso 4 enogastronomico 4 montano 3)
    (hotels Duecento Menabrea)
  )

  (location (name Siena)
    (region Toscana)
    (x -2)
    (y 8)
    (kind-of-tourism-and-stars sportivo 5 culturale 5)
    (hotels Acciaio Quattrocento)
  )

  (location (name Arezzo)
    (region Toscana)
    (x 0)
    (y 9)
    (kind-of-tourism-and-stars naturalistico 3 montano 4 culturale 2)
    (hotels Oro Cento)
  )

  (location (name Grosseto)
    (region Toscana)
    (x -3)
    (y 6)
    (kind-of-tourism-and-stars balneare 4 naturalistico 3 termale 5)
    (hotels Moretti Lupin)
  )

  (location (name Firenze)
    (region Toscana)
    (x -2)
    (y 11)
    (kind-of-tourism-and-stars culturale 5 religioso 3 enogastronomico 5 sportivo 2)
    (hotels Diamante Fujiko)
  )

  (location (name Napoli)
    (region Campania)
    (x 5)
    (y -10)
    (kind-of-tourism-and-stars culturale 5 religioso 3 enogastronomico 5 sportivo 5 balneare 3)
    (hotels Timon)
  )

  (location (name Salerno)
    (region Campania)
    (x 7)
    (y -12)
    (kind-of-tourism-and-stars culturale 3 religioso 3 enogastronomico 4 sportivo 3 balneare 3)
    (hotels Pumba)
  )

  (location (name Avellino)
    (region Campania)
    (x 6)
    (y -11)
    (kind-of-tourism-and-stars culturale 3 religioso 3 enogastronomico 5 sportivo 3 montano 4)
    (hotels Simba)
  )

  (location (name Benevento)
    (region Campania)
    (x 11)
    (y -10)
    (kind-of-tourism-and-stars culturale 5 religioso 3 enogastronomico 3 sportivo 2 montano 3)
    (hotels Nala)
  )
)
(deffacts question-attribute

        (question   (attribute new-number-of-stars)
                    (precursors modify is stelle)
                    (the-question "%nQual e' il minimo numero di stelle che l'hotel deve possedere?%n[1..4, indifferente]: ")
                    (valid-answers 1 2 3 4 indifferente))



        (question   (attribute new-budget)
                    (precursors modify is budget)
                    (the-question "%nQual e' il nuovo budget?%n[50,...,10000]:")
                    (valid-answers 50 10000))


        (question   (attribute new-number-of-days)
                    (precursors modify is #giorni)
                    (the-question "%nQuanti giorni vuoi andare in vacanza?%n[1,...,15]:")
                    (valid-answers 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15))


        (question   (attribute modify)
                    (precursors modify-research is si)
                    (the-question "%nCosa vuoi modificare?%n[#giorni,  budget, stelle]%n")
                    (valid-answers #giorni budget stelle stop))



        (question   (attribute modify-research)
                    (precursors modify-phase is TRUE)
                    (the-question "%nVuoi modificare i criteri di ricerca?%n[si no]:")
                    (valid-answers si no))



        ;not handled by the default rule (because of multiple choice possibility)
        (question   (attribute kind-of-tourism)
                    (the-question "%nQuale tipo di turismo preferisci?%n[Balneare, Montano, Lacustre, Naturalistico, Termale, Culturale, Religioso, Sportivo, Enogastronomico, indifferente]%n(Piu' scelte possibili. Inserisci una scelta alla volta. Se sei indeciso digata indifferente. Digita stop per fermarti)%n")
                    (valid-answers Balneare Montano Lacustre Naturalistico Termale Culturale Religioso Sportivo Enogastronomico indifferente stop))



        (question   (attribute region-to-avoid)
                    (the-question "%nC'e' una regione che vuoi evitare?%n[Toscana, Lazio, Umbria, Campania, no] (Non dare la risposta precedente): ")
                    (valid-answers Toscana Lazio Umbria Campania no))



        (question   (attribute preferred-region)
                    (the-question "%nDove preferisci andare?%n[Toscana, Lazio, Umbria, Campania, indifferente]: ")
                    (valid-answers Toscana Lazio Umbria Campania indifferente))



        (question   (attribute min-num-of-stars)
                    (the-question "%nQual e' il minimo numero di stelle che l'hotel deve possedere?%n[1..4, indifferente]: ")
                    (valid-answers 1 2 3 4 indifferente))



        (question   (attribute max-to-spend)
                    (the-question "%nQual e' il tuo budget?%n[50...10000]: ")
                    (valid-answers 50 10000));not handled by the default rule because of the big range



        (question   (attribute num-of-places)
                    (the-question "%nQuanti posti vorresti visitare?%n[1..3, indifferente]: ")
                    (valid-answers 1 2 3 indifferente))



        (question   (attribute num-of-people)
                    (the-question "%nQuante persone siete (incluso tu)?%n[1..15]: ")
                    (valid-answers 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15))



        (question   (attribute num-of-days)
                    (the-question "%nQuanti giorni vuoi andare in vacanza?%n[1..15]: ")
                    (valid-answers 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15))
)
