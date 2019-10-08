using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GestDepLib.Entities
{
    public partial class Pool
    {
        public Pool()
        {
            Lanes = new List<Lane>();
            //añadido
            tabla = new Dictionary<DateTime, Dictionary<Lane, int>>();

        }
        public Pool(DateTime OpeningHour, DateTime ClosingHour,
        int ZipCode, int Id, int DiscountRetired, int DiscountLocal,
        float freeSwimPrice)
        {
            this.OpeningHour = OpeningHour;
            this.ClosingHour = ClosingHour;
            this.ZipCode = ZipCode;
            this.Id = Id;
            this.DiscountRetired = DiscountRetired;
            this.DiscountLocal = DiscountLocal;
            this.FreeSwimPrice = freeSwimPrice;
            Lanes = new List<Lane>();
            //añadido
            tabla = new Dictionary<DateTime, Dictionary<Lane, int>>();
        }
        /* Constructor sobrecargado con el mismo orden que Program.cs*/
        public Pool(int Id, DateTime OpeningHour, DateTime ClosingHour,
             int ZipCode, int DiscountLocal, int DiscountRetired,
             double freeSwimPrice)
        {
            this.OpeningHour = OpeningHour;
            this.ClosingHour = ClosingHour;
            this.ZipCode = ZipCode;
            this.Id = Id;
            this.DiscountRetired = DiscountRetired;
            this.DiscountLocal = DiscountLocal;
            this.FreeSwimPrice = freeSwimPrice;
            Lanes = new List<Lane>();
            //añadido
            tabla = new Dictionary<DateTime, Dictionary<Lane, int>>();

        }
        // Método para añadir una Lane al atributo Lanes
        public void addLane(Lane l) { Lanes.Add(l); }
        // Método para recuperar una Lane pasandole su Number
        // (su id se genera automáticamente
        public Lane findLane(int LaneNum)
        {

            foreach (Lane la in Lanes)
            {
                if (la.Number == LaneNum) { return la; }
            }
            return null;
            //return new Lane(9);
        }
        // Método que recupera las Lineas libres un dia en una hora
        public int getFreeLanes(DateTime FechaConHora, Days dia)
        {
            int cont = this.Lanes.Count();
            Dictionary<Lane, int> l = tabla[FechaConHora];

            if (tabla.ContainsKey(FechaConHora))
            {

                foreach (Lane lane in Lanes)
                {
                    if (l[lane] > 0) { cont--; }
                }
            }
            return cont;
        }
        public bool compruebaSolapamientoEntrada(DateTime fechaConHora, Dictionary<Lane, int> dic)
        {
            bool solapamiento = false;
            Dictionary<Lane, int> dicLanePiscina;
            if (tabla.ContainsKey(fechaConHora))
            { // si en la piscina hay una entrada ese día a esa hora
                dicLanePiscina = tabla[fechaConHora];
                var lanesEntradas = dic.Keys.ToArray();
                foreach (Lane lane in lanesEntradas) // por cada lane de la piscina
                {
                    if (dic.ContainsKey(lane) && Lanes.Contains(lane))
                    {
                        if (dic[lane] > 0 // Si el valor de la lane en listaEntradas (entradas a añadir) es > 0
                            &&
                            dicLanePiscina[lane] > 0)
                        { // y para esa misma lane en piscina tambien es > 0 
                            return true; // si lo creasemos se solaparía 

                        }
                    }

                }
            }

            return solapamiento;
        }
        public void insertarEntrada(DateTime diaYHora, Dictionary<Lane, int> listaEntradas)
        {
            Dictionary<Lane, int> dicAux = new Dictionary<Lane, int>();
            if (tabla.ContainsKey(diaYHora))
            {
                Dictionary<Lane, int> dicLanePiscina = tabla[diaYHora];
                foreach (Lane lane in Lanes) // por cada lane de la piscina
                { int valor = 0;
                    if (listaEntradas.ContainsKey(lane)) {
                        if (listaEntradas[lane] > 0) {
                            valor = 1;
                        }
                    }
                    if(dicLanePiscina[lane] > 0) { valor = 1; }
                        dicAux.Add(lane, valor);
                }

            }
            else
            {
                foreach (Lane lane in Lanes) // por cada lane de la piscina
                {
                    if (listaEntradas.ContainsKey(lane) && listaEntradas[lane] > 0)
                    {
                        dicAux.Add(lane, 1);
                    }
                    else
                    {
                        dicAux.Add(lane, 0);
                    }

                }

            }

            if (tabla.ContainsKey(diaYHora)) { tabla.Remove(diaYHora); }
            this.tabla.Add(diaYHora, dicAux);


        }
        public DateTime devuelveHoraInicioTurno(DateTime fechaConHora)
        {
            DateTime hInicio = OpeningHour;
            DateTime hFin = ClosingHour;
            DateTime ant = OpeningHour;
            DateTime hInsertada = Convert.ToDateTime(fechaConHora.TimeOfDay);
            if (hInsertada > hFin || hInsertada < hInicio)
            {
                Console.WriteLine("La fecha insertada no entra en los horarios de la piscina");
            }
            else
            {
                while (hInicio <= hInsertada)
                {
                    ant = hInicio;
                    hInicio.AddMinutes(45.0);
                }
            }
            return ant;
        }
        public bool compruebaSolapamientoCurso(Course c)
        {

            List<DateTime> listaSolapadas = new List<DateTime>();
            List<DateTime> listaFechas = c.getDias();
            Dictionary<Lane, int> dicLane = c.getLanesDictionary();
            foreach (DateTime fechaConHora in listaFechas)
            {
                if (this.compruebaSolapamientoEntrada(fechaConHora, dicLane))
                {
                    return true;
                }

            }
            return false;
        }
        public void añadirHorariosCurso(Course c)
        {
                List<DateTime> l = c.getDias();
                Dictionary<Lane, int> d = c.getLanesDictionary();
                foreach (DateTime diaConHora in l)
                {
                    this.insertarEntrada(diaConHora, d);
                }
        }
        public List<DateTime> getListaTurnos() {
            List<DateTime> horas = new List<DateTime>();
            DateTime h = OpeningHour;
            horas.Add(h);
            while (DateTime.Compare(h, ClosingHour) < 0)
            {
                h = h.AddMinutes(45.0);
                horas.Add(h);
            }
            return horas;
        }
        public int getFreeLanes(DateTime diaConHora)
        {
            int cont = Lanes.Count();
            if (!tabla.ContainsKey(diaConHora))
            {
                return Lanes.Count();
            }else
            {
                Dictionary<Lane, int> d = tabla[diaConHora];
                foreach(Lane l in d.Keys.ToArray())
                {
                    if (d[l] > 0) { cont--; }
                }
                return cont;
            }
        }
        public String dibujaOcupacionSemana(DateTime fecha)
        {   
            List<DateTime> listaHorario = this.getListaTurnos();
            string st = "";
            st += "  SEMANA " + fecha.ToShortDateString() +" "+ fecha.AddDays(5.0).ToShortDateString()+"\n";
            st += "-------------------------------\n";
            st += "|     | L | M | X | J | V | S |\n";
            foreach(DateTime h in listaHorario)
            {
                TimeSpan t = h.TimeOfDay;
                DateTime correcto = new DateTime(fecha.Year,  fecha.Month, fecha.Day, h.Hour, h.Minute,h.Second);
                string s = t.ToString();
                s = s.Substring(0, 5);
                //st += "|" +s+ "|\n";
                st += "|" + s+"|" ;
                for (int i = 0; i < 6; i++)
                {
                     DateTime h1 = correcto.AddDays(i);
                    st += " " + getFreeLanes(h1) + " |";
                }
                st += "\n";
            }
            return st;
        }
    }
}



