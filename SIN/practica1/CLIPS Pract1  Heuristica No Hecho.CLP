(deffacts Ciudad
		
(Camino A B Ambos 10) 
(Camino A C Pie 8)
(Camino A E Ambos 10)
(Camino B A Ambos 10)
(Camino B C Pie 5)
(Camino B F Pie 6)
(Camino C A Pie 8)
(Camino C B Pie 5)
(Camino C G Pie 6)
(Camino C D Pie 6)
(Camino D C Pie 6)
(Camino D H Ambos 14)
(Camino E A Ambos 10)
(Camino E I Pie 20)
(Camino E J Ambos 9)
(Camino F B Pie 6)
(Camino F K Pie 10)
(Camino F L Pie 6)
(Camino G C Pie 6)
(Camino G H Pie 8)
(Camino G L Pie 9)
(Camino G M Pie 12)
(Camino H D Ambos 14)
(Camino H C Pie 6)
(Camino H G Pie 8)
(Camino H I Ambos 12)
(Camino I H Ambos 12)
(Camino I E Pie 20)
(Camino I O Pie 2)
(Camino J E Ambos 9)
(Camino J O Ambos 7)
(Camino K F Pie 10)
(Camino K L Ambos 2)
(Camino L K Ambos 2)
(Camino L G Pie 9)
(Camino L M Ambos 7)
(Camino L F Pie 6)
(Camino L P Ambos 6)
(Camino M L Ambos 7)
(Camino M G Pie 12)
(Camino M Q Pie 2)
(Camino O I Pie 2)
(Camino O J Ambos 7)
(Camino O N Ambos 8)
(Camino P L Ambos 6)
(Camino P Q Pie 2)
(Camino P R Ambos 4)
(Camino R P Ambos 4)
(Camino R Q Pie 3)
(Camino Q M Pie 2)
(Camino Q P Pie 2)
(Camino Q R Pie 3)
(Camino Q N Pie 6)
(Camino N Q Pie 6)
(Camino N O Ambos 8)
(Base A B H J K M N R)
)

(defglobal ?*f* = 1)
(defglobal ?*barrios* = (create$ A 1 B 2 C 2 D 2 E 2 J 2 F 3 G 3 H 3 I 3 O 3 K 4 L 4 M 4 N 4 P 5 Q 5 R 6))
(defglobal ?*minCam* = (create$ A 8 B 5 C 5 D 6 E 9 J 7 F 6 G 6 H 6 I 2 O 2 K 2 L 2 M 2 N 6 P 2 Q 2 R 3))
;;(defglobal ?*res* = 0)
;;)
;;f(n)=g(n)+h(n)   h(n)=|DistBarrios(n)|*min(Cam(n))*Sit(n)


;;nth accede a la posicion de estado
;;(abs ?x)  pone el valor absoluto

(deffunction heuristica ( ?x ?f ?bipie $?ba)

	(bind ?i (member$ ?x ?*barrios*))
	(bind ?barriox (nth$ (+ ?i 1) ?*barrios*))
	
	(bind ?i (member$ ?f ?*barrios*))
	(bind ?barriof (nth$ (+ ?i 1) ?*barrios*))
	
	(bind ?costebarrio (abs (- ?barriof ?barriox)))
	
	(bind ?i2 (member$ ?x ?*minCam*))
	(bind ?CaminoMinimo (nth$ (+ ?i2 1) ?*minCam*))
	
	(if (eq ?bipie  pie) then  (bind ?sit 1))
	(if (or (eq ?bipie  bici) (member$ ?x $?ba)) then  (bind ?sit 0.5))
	
	(bind ?res (* ?CaminoMinimo ?sit))
	(bind ?res (* ?res ?costebarrio))
	(printout t "sit" ?sit crlf)
	(printout t "Camino minimo" ?CaminoMinimo crlf)
	(printout t "Coste barrio" ?costebarrio crlf)
	(integer ?res)
	;; ¿debo fijar *f* = *res* o hacer un return


)


(deffunction control ( ?x ?f ?bipie ?c $?ba)
    (bind ?*f* (heuristica ?x ?f ?bipie $?ba))
    (bind ?*f* (+ ?*f* ?c))
)

	  ;;IR A PIE--------------------------------------------------------
	(defrule IraPie
		;;(declare (salience (- 0 ?*f*)))
		(transporte ?a ?f ?x pie coste ?c PATH $?cam numpasos ?pas numOp ?Ops)
		(Camino ?x ?y ?Ambos ?z )
		(Base $?ba)
		(profundidad-maxima ?prof)
		(test (< ?pas ?prof))
		(test (control ?y ?f pie (+ ?c ?z) $?ba))
		;; el estado que genera la regla
	=>
		(assert (transporte ?a ?f ?y pie coste (+ ?c ?z) PATH $?cam ?y numpasos (+ ?pas 1) numOp (+ ?Ops 1)))
		(printout t "ESTOY EN " ?x " y VOY ANDANDO a " ?y crlf)
	)
	
	;;IR EN BICI--------------------------------------------------------
	(defrule IrenBicicleta
		;;(declare (salience (- 0 ?*f*)))
		(transporte ?a ?f ?x bici coste ?c PATH $?cam numpasos ?pas numOp ?Ops )
		(Camino ?x ?y Ambos ?z )
		(profundidad-maxima ?prof)
		(test (< ?num ?prof))
	=>
		(assert (transporte ?a ?f ?y bici coste (+ ?c (/ ?z 2)) PATH $?cam ?y numpasos (+ ?pas 1) numOp (+ ?Ops 1)))
		(printout t "ESTOY EN " ?x " y VOY EN BICI a " ?y crlf)
	)
	
	;;COGER LA BICI-----------------------------------------------------
	(defrule CogerBici
	;;(declare (salience (- 0 ?*f*)))
	(transporte ?a ?f ?x pie coste ?c PATH $?cosas ?ult)
	(Base $?j)
	(test (member$ ?x $?j ))
	=>
	(assert(transporte ?a ?f ?x bici coste (+ ?c 1) PATH $?cosas (+ ?ult 1)))
	(printout t "ESTOY EN " ?x " COJO BICI" crlf)
	)
	
	;;DEJAR LA BICI-----------------------------------------------------
	(defrule DejarBici
	;;(declare (salience (- 0 ?*f*)))-
	(transporte ?a ?f ?x bici coste ?c PATH $?cosas ?ult)
	(Base $?j)
	(test (member$ ?x $?j ))
	=>
	(assert(transporte ?a ?f ?x pie coste (+ ?c 1) PATH $?cosas (+ ?ult 1) ))
	(printout t "ESTOY EN " ?x " DEJO BICI" crlf)
	)
	
	;;PARADA FINAL-----------------------------------------------------
	(defrule Parada
    (declare (salience 100))
	(transporte ?a ?f ?f pie coste ?c PATH $?datos)
   =>
    (printout t "ESTOY EN " ?f " PARADA FINAL" crlf )
	(printout t "Resultado Camino :" ?a $?datos crlf)
	(printout t "Coste Total :" ?c crlf)
    (halt))
	
	
	;;INICIO-----------------------------------------------------------
	(deffunction inicio ()
	(set-salience-evaluation when-activated)
        (reset)
	(printout t "Profundidad Maxima:= " )
	(bind ?prof (read))
	(printout t "Tipo de Busqueda " crlf "    1.- Anchura" crlf "    2.- Profundidad" crlf )
	(bind ?r (read))
	(if (= ?r 1)
	       then    (set-strategy breadth)
	       else   (set-strategy depth))
        (printout t " Ejecuta run para poner en marcha el programa " crlf)
	
	(assert (transporte A B A pie coste 0 PATH numpasos 0 numOp 0 ))
	(assert (profundidad-maxima ?prof))
)
