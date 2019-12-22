;;*********
;;* MAIN *
;;********

(defmodule MAIN (export ?ALL))


(deffunction MAIN::ask-question (?question ?allowed-values)
   (printout t (format nil ?question))
   (bind ?answer (read))
   (while (not (member ?answer ?allowed-values)) do
      (printout t "NOT A VALID ANSWER" crlf)
      (printout t (format nil ?question))
      (bind ?answer (read)))
   ?answer)







(defrule MAIN::start
  (declare (salience 10000))
  =>
  (set-fact-duplication TRUE)
  (focus QUESTIONS CHOOSE-SPECIFICATIONS GENERATE-VACATION PRINT-RESULTS QUESTIONS MODIFY-RESEARCH CHOOSE-SPECIFICATIONS GENERATE-VACATION PRINT-RESULTS)
)



(defrule MAIN::combine-certainties
  (declare (salience 100)
           (auto-focus TRUE))
  ?rem1 <- (attribute (name ?rel) (value ?val) (certainty ?per1))
  ?rem2 <- (attribute (name ?rel) (value ?val) (certainty ?per2))
  (test (neq ?rem1 ?rem2))
  =>
  (retract ?rem1)
  (modify ?rem2 (certainty (/ (- (* 100 (+ ?per1 ?per2)) (* ?per1 ?per2)) 100))))










;;*************
;;* QUESTIONS *
;;*************

(defmodule QUESTIONS (import MAIN ?ALL)
                     (export ?ALL))


;define a question



(defrule QUESTIONS::ask-a-question
   ?f <- (question (already-asked FALSE)
                   (precursors)
                   (the-question ?the-question)
                   (attribute ?the-attribute& ~kind-of-tourism & ~max-to-spend & ~new-budget)
                   (valid-answers $?valid-answers))
   =>
   (modify ?f (already-asked TRUE))
   (assert (attribute (name ?the-attribute)
                      (value (ask-question ?the-question ?valid-answers)))))



(defrule QUESTIONS::ask-multiple-question-tourism
   (question (already-asked FALSE)
                   (precursors)
                   (the-question ?the-question)
                   (attribute kind-of-tourism)
                   (valid-answers $?valid-answers))
   =>
   (assert (attribute (name kind-of-tourism)
                      (value (ask-question ?the-question ?valid-answers))))
   ;fa in modo che venga chiesta di nuovo
   (refresh ask-multiple-question-tourism))



(defrule QUESTIONS::ask-multiple-question-modify
  (question (already-asked FALSE)
                  (precursors)
                  (the-question ?the-question)
                  (attribute modify)
                  (valid-answers $?valid-answers))
  =>
  (assert (attribute (name kind-of-tourism)
                     (value (ask-question ?the-question ?valid-answers))))
  ;fa in modo che venga chiesta di nuovo
  (refresh ask-multiple-question-modify))



(defrule QUESTIONS::stop-tourism-question (declare (salience 1000))
  (attribute (name kind-of-tourism) (value stop | indifferente))
  ?f <- (question (already-asked FALSE)
                   (precursors)
                   (the-question ?the-question)
                   (attribute kind-of-tourism)
                   (valid-answers $?valid-answers))
  =>
  (modify ?f (already-asked TRUE)))



(defrule QUESTIONS::remove-unnecessary-unknown-tourism
  (attribute (name kind-of-tourism) (value ?v& ~stop))
  ?a <- (attribute (name kind-of-tourism) (value stop))
  =>
  (retract ?a))



(defrule QUESTIONS::remove-preferred-region-from-region-to-avoid
  (attribute (name preferred-region) (value ?r& ~indifferente))
  ?q <- (question (attribute region-to-avoid) (valid-answers $?pre ?r $?post))
  =>
  (modify ?q (valid-answers ?pre ?post)))



(defrule QUESTIONS::ask-budget
  ?f <- (question (already-asked FALSE)
                 (precursors)
                 (the-question ?the-question)
                 (attribute ?a& max-to-spend | new-budget)
                 (valid-answers $?valid-answers))
  =>
  (printout t (format nil ?the-question))
  (assert (attribute (name ?a)
                    (value (read))))
  (modify ?f (already-asked TRUE))
)



(defrule QUESTIONS::precursor-is-satisfied
   ?f <- (question (already-asked FALSE)
                   (precursors ?name is ?value $?rest))
         (attribute (name ?name) (value ?value))
   =>
   (if (eq (nth 1 ?rest) and)
    then (modify ?f (precursors (rest$ ?rest)))
    else (modify ?f (precursors ?rest))))



(defrule QUESTIONS::precursor-is-not-satisfied
   ?f <- (question (already-asked FALSE)
                   (precursors ?name is-not ?value $?rest))
         (attribute (name ?name) (value ~?value))
   =>
   (if (eq (nth 1 ?rest) and)
    then (modify ?f (precursors (rest$ ?rest)))
    else (modify ?f (precursors ?rest))))








;;*************************
;;* CHOOSE-SPECIFICATIONS *
;;*************************

(defmodule CHOOSE-SPECIFICATIONS   (import MAIN ?ALL)
                                   (export ?ALL))


;per questioni di leggibilità
(defrule CHOOSE-SPECIFICATIONS::retract-best-location
  ?bl <- (attribute (name best-location))
  (attribute (name best-hotel) (value ?bp))
  =>
  (retract ?bl)
)



(defrule CHOOSE-SPECIFICATIONS::assert-triple-distances
  (attribute (name double-distance) (value ?a ?b ?d) (certainty ?cfdd))
  (attribute (name num-of-places) (value ?nop))
  (attribute (name best-place) (value ?bp))

  (attribute (name best-location) (value ?bp))
  (attribute (name best-location) (value ?a))
  (attribute (name best-location) (value ?b))

  (location (name ?bp) (x ?x3) (y ?y3))
  (location (name ?a) (x ?x1) (y ?y1))
  (location (name ?b) (x ?x2) (y ?y2))

  (test (eq ?nop 3))
  (test (neq ?bp ?a))
  (test (neq ?bp ?b))

  (not (attribute (name triple-distance)(value ?a ?b ?bp $?)))
  (not (attribute (name triple-distance)(value ?b ?a ?bp $?)))
  (not (attribute (name triple-distance)(value ?a ?bp ?b $?)))
  (not (attribute (name triple-distance)(value ?b ?bp ?a $?)))
  (not (attribute (name triple-distance)(value ?bp ?a ?b $?)))
  (not (attribute (name triple-distance)(value ?bp ?b ?a $?)))

  =>

  (bind ?d13 (+ (abs (- ?x1 ?x3)) (abs (- ?y1 ?y3))))
  (bind ?d23 (+ (abs (- ?x2 ?x3)) (abs (- ?y2 ?y3))))
  (bind ?dst (min ?d13 ?d23))

  (if (> ?dst 0) then (bind ?cftd (div 90 ?dst)) else (bind ?cftd 100))
  (bind ?cf (min ?cftd ?cfdd))

  (if (and (<= ?dst 5) (eq ?dst ?d13)) then (assert (attribute (name triple-distance) (value ?b ?a ?bp ?d ?dst) (certainty (min ?cf 100)))))
  (if (and (<= ?dst 5) (eq ?dst ?d23)) then (assert (attribute (name triple-distance) (value ?a ?b ?bp ?d ?dst) (certainty (min ?cf 100)))))
)



;couple of places
(defrule CHOOSE-SPECIFICATIONS::assert-double-distances
  (attribute (name best-location) (value ?bl))
  (attribute (name best-place) (value ?bp))
  (location (name ?bl) (x ?x1) (y ?y1))
  (location (name ?bp) (x ?x2) (y ?y2))
  (test (neq ?bl ?bp))
  (not (attribute (name double-distance) (value ?bl ?bp $?)))
  (not (attribute (name double-distance) (value ?bp ?bl $?)))
  =>
  (bind ?d (+ (abs (- ?x1 ?x2)) (abs (- ?y1 ?y2))))
  (bind ?cf (div 100 ?d))
  (if (<= ?d 5) then (assert (attribute (name double-distance) (value ?bl ?bp ?d) (certainty ?cf))))
)



(defrule CHOOSE-SPECIFICATIONS::assert-multiple-destinations
  (attribute (name num-of-places) (value ?nop& ~indifferente))
  (attribute (name best-place) (value ?bp) (certainty ?cf))
  (location (name ?bp) (x ?x) (y ?y))
  (test (> ?nop 1))
  =>
  (assert (attribute (name best-location) (value ?bp) (certainty ?cf)))
)



(defrule CHOOSE-SPECIFICATIONS::rank-hotels-by-location
  ?h <- (attribute (name available-hotel) (value ?ah))
  (attribute (name best-place) (value ?bp) (certainty ?cfp))
  (hotel (name ?ah) (location ?bp) (cost ?c))
  =>
  (assert (attribute (name best-hotel) (value ?ah) (certainty ?cfp)))
  (retract ?h)
)



(defrule CHOOSE-SPECIFICATIONS::assert-hotels-by-stars-availability-price-and-location
  (attribute (name best-num-of-stars) (value ?bns))
  (attribute (name best-place) (value ?bp) (certainty ?cfp))
  (attribute (name price-per-night) (value ?ppn))
  (attribute (name num-of-rooms) (value ?nor))
  (hotel (name ?hn) (location ?bp) (stars ?bns) (cost ?c) (num-of-available-rooms ?nar))
  (test (>= ?ppn ?c))
  (test (>= ?nar ?nor))
  =>
  (bind ?cf (* ?bns 20))
  (assert (attribute (name available-hotel) (value ?hn) (certainty ?cf)))
)



(defrule CHOOSE-SPECIFICATIONS::assert-default-num-of-places
  ?nop <- (attribute (name num-of-places) (value indifferente))
  =>
  (modify ?nop (value 1))
)



(defrule CHOOSE-SPECIFICATIONS::assert-best-num-of-stars
  (attribute (name min-num-of-stars) (value ?mnos))
  (attribute (name num-of-people) (value ?nop))
  (attribute (name num-of-days) (value ?nod))
  (attribute (name max-to-spend) (value ?mts))

  =>
  (bind ?nor (div (+ ?nop 1) 2))
  (assert (attribute (name num-of-rooms) (value ?nor)))
  (bind ?avg-price-per-night (div ?mts ?nod ?nor))
  (assert (attribute (name price-per-night) (value ?avg-price-per-night)))
  (bind ?max-num-of-stars (+ 1 (div (- ?avg-price-per-night 50) 25)))
  (bind ?max-num-of-stars (min ?max-num-of-stars 4))
  (if (eq ?mnos indifferente) then (bind ?mnos 1))

  (while (>= ?max-num-of-stars ?mnos)
    do
    (assert (attribute (name best-num-of-stars) (value ?max-num-of-stars)))
    (bind ?max-num-of-stars (- ?max-num-of-stars 1)))
)



(defrule CHOOSE-SPECIFICATIONS::assert-best-places-by-other-region
  ?p <- (attribute (name available-place) (value ?ap) (certainty ?cf))
  (attribute (name preferred-region) (value ?pr))
  (attribute (name region-to-avoid) (value ?rta))
  (location (name ?ap) (region ?r))
  (test (neq ?r ?pr))
  (test (neq ?r ?rta))
  =>
  (assert (attribute (name best-place) (value ?ap) (certainty ?cf)))
  (retract ?p)
)



(defrule CHOOSE-SPECIFICATIONS::assert-best-places-by-preferred-region
  ?p <- (attribute (name available-place) (value ?ap))
  (attribute (name preferred-region) (value ?pr))
  (location (name ?ap) (region ?pr))
  =>
  (assert (attribute (name best-place) (value ?ap)))
  (retract ?p)
)



(defrule CHOOSE-SPECIFICATIONS::assert-other-places
  (attribute (name preferred-region) (value ?pr))
  (attribute (name region-to-avoid) (value ?rta))
  (location (name ?name) (region ?r))
  (test (neq ?r ?pr))
  (test (neq ?r ?rta))
  =>
  (assert (attribute (name available-place) (value ?name) (certainty 0)))
)



(defrule CHOOSE-SPECIFICATIONS::assert-places-for-unknown-kind-tourism
  (attribute (name region-to-avoid) (value ?rta))
  (attribute (name kind-of-tourism) (value ?kot& indifferente))
  (location (region ?r) (name ?name))
  (test (neq ?r ?rta))
  =>
  (assert (attribute (name available-place) (value ?name) (certainty 0)))
)



(defrule CHOOSE-SPECIFICATIONS::assert-places-for-kind-of-tourism
  (attribute (name region-to-avoid) (value ?rta))
  (attribute (name kind-of-tourism) (value ?kot))
  (location (region ?r) (name ?name) (kind-of-tourism-and-stars $? ?k ?s $?))
  (test (neq ?r ?rta))
  (test (eq (lowcase ?kot) ?k))
  =>
  (bind ?c (* 20.0 ?s))
  (assert (attribute (name available-place) (value ?name) (certainty ?c)))
)










;;*************************
;;*   GENERATE-VACATION   *
;;*************************

(defmodule GENERATE-VACATION       (import CHOOSE-SPECIFICATIONS ?ALL)
                                   (export ?ALL))


(defrule GENERATE-VACATION::generate-triple-stage-vacation
  (attribute (name max-to-spend) (value ?mts))
  (attribute (name triple-distance) (value ?a ?b ?c ?d1 ?d2) (certainty ?cfd))
  (attribute (name num-of-places) (value ?nop))
  (attribute (name num-of-days) (value ?nod))
  (attribute (name num-of-rooms) (value ?nor))
  (attribute (name best-hotel) (value ?bh1) (certainty ?cfh1))
  (attribute (name best-place) (value ?a) (certainty ?cfp1))

  (attribute (name best-hotel) (value ?bh2) (certainty ?cfh2))
  (attribute (name best-place) (value ?b) (certainty ?cfp2))

  (attribute (name best-hotel) (value ?bh3) (certainty ?cfh3))
  (attribute (name best-place) (value ?c) (certainty ?cfp3))

  (hotel (name ?bh1) (location ?a) (cost ?c1) (stars ?s1))
  (hotel (name ?bh2) (location ?b) (cost ?c2) (stars ?s2))
  (hotel (name ?bh3) (location ?c) (cost ?c3) (stars ?s3))
  (not (attribute (name best-vacation) (value ?a ?b ?c ?bh1 ?bh2 ?bh3 $? ?s1 ?s2 ?s2 $? ?nor)))
  (test (>= ?nod 3))
  =>
  (if (eq ?nod 3)
    then (bind ?nod1 (div ?nod ?nop))
         (bind ?nod2 (div ?nod ?nop))
         (bind ?nod3 (- ?nod ?nod1 ?nod2))
    else (bind ?nod1 (+ (div ?nod ?nop) 1))
         (bind ?nod2 (+ (div ?nod ?nop) 1))
         (bind ?nod3 (- ?nod ?nod1 ?nod2))
  )

  (bind ?price1 (* ?c1 ?nor ?nod1))
  (bind ?price2 (* ?c2 ?nor ?nod2))
  (bind ?price3 (* ?c3 ?nor ?nod3))

  (bind ?total (+ ?price1 ?price2 ?price3))
  (bind ?cf_price (* (div (- ?mts ?total) ?mts) 100))
  (bind ?cf_place (/ (+ ?cfp1 ?cfp2 ?cfp3) 3))
  (bind ?cf (/ (- (* 100 (+ ?cf_price ?cf_place)) (* ?cf_price ?cf_place)) 100))
  (assert (attribute (name best-vacation) (value ?a ?b ?c ?bh1 ?bh2 ?bh3 ?nod1 ?nod2 ?nod3 ?s1 ?s2 ?s3 ?price1 ?price2 ?price3 ?nor) (certainty (min ?cf 100))))
)



(defrule GENERATE-VACATION::generate-double-stage-vacation
  (attribute (name max-to-spend) (value ?mts))
  (attribute (name double-distance) (value ?a ?b ?d) (certainty ?cfd))
  (attribute (name num-of-places) (value ?nop))
  (attribute (name num-of-days) (value ?nod))
  (attribute (name num-of-rooms) (value ?nor))

  (attribute (name best-hotel) (value ?bh1) (certainty ?cfh1))
  (attribute (name best-place) (value ?a) (certainty ?cfp1))

  (attribute (name best-hotel) (value ?bh2) (certainty ?cfh2))
  (attribute (name best-place) (value ?b) (certainty ?cfp2))

  (hotel (name ?bh1) (location ?a) (cost ?c1) (stars ?s1))
  (hotel (name ?bh2) (location ?b) (cost ?c2) (stars ?s2))

  (not (attribute (name best-vacation) (value ?a ?b ?bh1 ?bh2 $? ?s1 ?s2 $? ?nor)))
  (test (eq ?nop 2))
  (test (>= ?nod 2))

  =>

  (if (eq ?nod 2)
    then (bind ?nod1 (div ?nod ?nop)) (bind ?nod2 (- ?nod ?nod1))
    else (bind ?nod1 (+ (div ?nod ?nop) 1)) (bind ?nod2 (- ?nod ?nod1))
  )

  (bind ?price1 (* ?c1 ?nor ?nod1))
  (bind ?price2 (* ?c2 ?nor ?nod2))
  (bind ?total (+ ?price1 ?price2))
  (bind ?cf_place (/ (+ ?cfp1 ?cfp2) 2))
  (bind ?cf_price (* (div (- ?mts ?total) ?mts) 100))
  (bind ?cf (/ (- (* 100 (+ ?cf_price ?cf_place)) (* ?cf_price ?cf_place)) 100))
  (assert (attribute (name best-vacation) (value ?a ?b ?bh1 ?bh2 ?nod1 ?nod2 ?s1 ?s2 ?price1 ?price2 ?nor) (certainty (min 100 ?cf))))
)



(defrule GENERATE-VACATION::generate-simple-vacation
  (attribute (name max-to-spend) (value ?mts))
  (attribute (name num-of-places) (value ?nop))
  (attribute (name num-of-days) (value ?nod))
  (attribute (name num-of-rooms) (value ?nor))

  (attribute (name best-hotel) (value ?bh) (certainty ?cfh))
  (attribute (name best-place) (value ?bp) (certainty ?cfp))

  (hotel (name ?bh) (location ?bp) (cost ?c) (stars ?s))

  (test (eq ?nop 1))

  =>
  (bind ?price (* ?c ?nor ?nod))
  (bind ?cf_price (* (div (- ?mts ?price) ?mts) 100))
  (bind ?cf (/ (- (* 100 (+ ?cf_price ?cfp)) (* ?cf_price ?cfp)) 100))

  (assert (attribute (name best-vacation) (value ?bh ?nor ?bp ?nod ?s ?price) (certainty ?cf)))
)










;;*****************************
;;* PRINT BEST VACATION RULES *
;;*****************************

(defmodule PRINT-RESULTS (import MAIN ?ALL))


(defrule PRINT-RESULTS::header
   (declare (salience 10))
   (attribute (name num-of-places) (value ?nop))
   =>
   (printout t "HOTEL     #ROOMS      PLACE     #DAYS     #STARS        COST      CF" crlf)
   (if (eq ?nop 1) then (assert (phase print-single-stage-vacation)))
   (if (eq ?nop 2) then (assert (phase print-double-stage-vacation)))
   (if (eq ?nop 3) then (assert (phase print-triple-stage-vacation)))
   (assert (attribute (name printed) (value 0)))
)



(defrule PRINT-RESULTS::print-single-stage-vacation
  ?p <- (attribute (name printed) (value ?np))
  ?rem <- (attribute (name best-vacation) (value ?hotel ?rooms ?place ?days ?stars ?price) (certainty ?cv))
  (not (attribute (name best-vacation)(certainty ?cv1&:(> ?cv1 ?cv))))
  (test (< ?np 5))
  =>
  ;TO HAVE CF BETWEEN [0, 100]
  (bind ?ncv (/ (* (+ ?cv 100) 100) 200))
  (format t "%-12s %d %12s %7d %9d %15.2f %6d%%%n" ?hotel ?rooms ?place ?days ?stars ?price ?ncv)
  (bind ?up (+ ?np 1))
  (modify ?p (value ?up))
  (retract ?rem)
)



(defrule PRINT-RESULTS::print-double-stage-vacation
  ?p <- (attribute (name printed) (value ?np))
  ?rem <- (attribute (name best-vacation) (value ?place1 ?place2 ?hotel1 ?hotel2 ?days1 ?days2 ?stars1 ?stars2 ?price1 ?price2 ?rooms) (certainty ?cv))
  ;?rem_d <- (attribute (name best-vacation) (value ?place1 ?place2 $?rest))
  ;(test (neq ?rem ?rem_d))
  (not (attribute (name best-vacation)(certainty ?cv1&:(> ?cv1 ?cv))))
  (test (< ?np 5))
  =>
  ;TO HAVE CF BETWEEN [0, 100]
  (bind ?ncv (/ (* (+ ?cv 100) 100) 200))
  (format t "%-12s %d %12s %7d %9d %15.2f %6d%%%n" ?hotel1 ?rooms ?place1 ?days1 ?stars1 ?price1 ?ncv)
  (format t "%-12s %d %12s %7d %9d %15.2f %6d%%%n" ?hotel2 ?rooms ?place2 ?days2 ?stars2 ?price2 ?ncv)
  (printout t crlf)
  (bind ?up (+ ?np 1))
  (modify ?p (value ?up))
  (retract ?rem)
  ;(retract ?rem_d)
)



(defrule PRINT-RESULTS::print-triple-stage-vacation
  ?p <- (attribute (name printed) (value ?np))
  ?rem <- (attribute (name best-vacation) (value ?place1 ?place2 ?place3 ?hotel1 ?hotel2 ?hotel3 ?days1 ?days2 ?days3 ?stars1 ?stars2 ?stars3 ?price1 ?price2 ?price3 ?rooms) (certainty ?cv))
  ;?rem_d <- (attribute (name best-vacation) (value ?place1 ?place2 ?place3 $?))
  ;(test (neq ?rem ?rem_d))
  (not (attribute (name best-vacation)(certainty ?cv1&:(> ?cv1 ?cv))))
  (test (< ?np 5))
  =>
  ;TO HAVE CF BETWEEN [0, 100]
  (bind ?ncv (/ (* (+ ?cv 100) 100) 200))
  (format t "%-12s %d %12s %7d %9d %15.2f %6d%%%n" ?hotel1 ?rooms ?place1 ?days1 ?stars1 ?price1 ?ncv)
  (format t "%-12s %d %12s %7d %9d %15.2f %6d%%%n" ?hotel2 ?rooms ?place2 ?days2 ?stars2 ?price2 ?ncv)
  (format t "%-12s %d %12s %7d %9d %15.2f %6d%%%n" ?hotel3 ?rooms ?place3 ?days3 ?stars3 ?price3 ?ncv)
  (printout t crlf)
  (bind ?up (+ ?np 1))
  (modify ?p (value ?up))
  (retract ?rem)
  ;(retract ?rem_d)
)



(defrule PRINT-RESULTS::end-spaces
(declare (salience -10))
(attribute (name printed) (value ?np))
=>
(assert (attribute (name modify-phase) (value TRUE)))
(if (eq ?np 0) then (printout t "Nessun pacchetto trovato che soddisfi i requisiti specificati" crlf))
(printout t crlf))










;;********************
;;* MODIFY RESEARCH *
;;********************

(defmodule MODIFY-RESEARCH (import MAIN ?ALL)
                           (import QUESTIONS ?ALL)
                           (export ?ALL)
                           )


(defrule MODIFY-RESEARCH::final
  (attribute (name modify-research) (value si))
  ?p <- (attribute (name printed) (value ?v& ~0))

  =>
  (modify ?p (value 0))
)



;;*************************
;;* MODIFY CRITERIA #DAYS *
;;*************************

(defrule MODIFY-RESEARCH::retract-num-of-days
(attribute (name modify-research) (value si))
(attribute (name modify) (value #giorni))
?anod <- (attribute (name new-number-of-days) (value ?bnod))
?abnod <- (attribute (name num-of-days))
(not (exists (attribute (name best-vacation))))
 =>
(modify ?abnod (value ?bnod))
(retract ?anod)
)



(defrule MODIFY-RESEARCH::retract-vacation-by-days
(attribute (name modify-research) (value si))
(attribute (name modify) (value #giorni))
 ?bv <- (attribute (name best-vacation))
 =>
 (retract ?bv)
)



(defrule MODIFY-RESEARCH::retract-vacation-for-budget
 (attribute (name modify-research) (value si))
 ?bv <- (attribute (name best-vacation))
 (attribute (name modify) (value budget))
 =>
 (retract ?bv)
)



;;**************************
;;* MODIFY CRITERIA BUDGET *
;;**************************

(defrule MODIFY-RESEARCH::retract-hotel-for-budget
 (attribute (name modify-research) (value si))
 ?bh <- (attribute (name best-hotel))
 (attribute (name modify) (value budget))
 =>
 (retract ?bh)
)



(defrule MODIFY-RESEARCH::retract-vacation-for-budget
 (attribute (name modify-reserch) (value si))
 ?bv <- (attribute (name best-vacation))
 (attribute (name modify) (value budget))
 =>
 (retract ?bv)
)



(defrule MODIFY-RESEARCH::modify-criteria-budget
  (attribute (name modify-research) (value si))
  (attribute (name modify) (value budget))
  ?anb <- (attribute (name new-budget) (value ?nb))
  ?mtp <- (attribute (name max-to-spend))
  =>
  (modify ?mtp (value ?nb))
  (retract ?anb)
)


;;*************************
;;* MODIFY CRITERIA STARS *
;;*************************

(defrule MODIFY-RESEARCH::modify-best-num-of-stars
  (declare (salience -15))
  (attribute (name modify-research) (value si))
  (attribute (name modify) (value stelle))
  (attribute (name min-num-of-stars) (value ?mnos))
  ?abnos <- (attribute (name best-num-of-stars) (value ?bnos))
  (test (< ?bnos ?mnos))
  =>
  (retract ?abnos)
)



(defrule MODIFY-RESEARCH::modify-min-num-of-stars
  (declare (salience -10))
  (attribute (name modify-research) (value si))
  (attribute (name modify) (value stelle))
  ?mnos <- (attribute (name min-num-of-stars))
  ?anos <- (attribute (name new-number-of-stars) (value ?nos))
  =>
  (modify ?mnos (value ?nos))
  (retract ?anos)
)



(defrule MODIFY-RESEARCH::retract-best-vacation-by-stars
  (attribute (name modify-research) (value si))
  (attribute (name modify) (value stelle))
  (hotel (name ?h))
  (not (exists (attribute (name best-hotel) (value ?h))))
  ?bv <- (attribute (name best-vacation) (value $?v))
  (test (member$ ?h $?v))
  =>
  (retract ?bv)
)



(defrule MODIFY-RESEARCH::retract-hotel-by-stars
  (attribute (name modify-research) (value si))
  (attribute (name modify) (value stelle))
  (attribute (name new-number-of-stars) (value ?nos))
  (attribute (name best-num-of-stars) (value ?bnos))
  (test (< ?bnos ?nos))
  (hotel (name ?h) (stars ?bnos))
  ?bh <- (attribute (name best-hotel) (value ?h))
  =>
  (retract ?bh)
)
