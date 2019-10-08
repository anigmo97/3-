using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GestDepLib.Entities
{
    public partial class TablaOcupacion
    {
        public TablaOcupacion(Pool p,DateTime apertura,DateTime cierre)
        {
            this.PoolId = p.Id;
            this.OpeningHour = p.OpeningHour;
            this.ClosingHour = p.ClosingHour;
            this.num_turnos = calcula_num_turnos();

            Console.WriteLine("calculados los turnos");

            ArrayList firstDimension = new ArrayList();
            ArrayList secondDimensionChild = new ArrayList();
            ArrayList thirdDimensionChild = new ArrayList();


            for (int i = 0; i <= 7; i++)
            {
                thirdDimensionChild.Add(0);
            }
            for (int i = 0; i < num_turnos; i++)
            {
                secondDimensionChild.Add(thirdDimensionChild);
            }
            for (int i = 0; i < 7; i++) { firstDimension.Add(secondDimensionChild); }
            tabla = firstDimension;
        
    }


        public int calcula_num_turnos()
        {
            int num_turnos = 0;
            DateTime h = Convert.ToDateTime(OpeningHour.Hour + ":" + OpeningHour.Minute + ":00");
            while (DateTime.Compare(h, ClosingHour) < 0){
                h = h.AddMinutes(45.0);
                num_turnos++;
            }
            if (DateTime.Compare(h, ClosingHour) < 0) { num_turnos++; }
            return num_turnos;
        }



        public int indexaDia(Days d)
        {
            switch (d)
            {
                case Days.Monday:
                    return 0;
                case Days.Tuesday:
                    return 1;
                case Days.Wednesday:
                    return 2;
                case Days.Thursday:
                    return 3;
                case Days.Friday:
                    return 4;
                case Days.Saturday:
                    return 5;
                case Days.Sunday:
                    return 6;
            }
            return -1;
        }
        public int indexaTurno(DateTime hora)
        {
            int num_turnos = 0;
            if (DateTime.Compare(hora, ClosingHour) < 0) { return -1; }
            DateTime h = Convert.ToDateTime(OpeningHour.Hour + ":" + OpeningHour.Minute + ":00");
            while (DateTime.Compare(h, hora) < 0 && DateTime.Compare(OpeningHour, hora) <= 0)
            {

                h = h.AddMinutes(45.0);
                num_turnos++;
            }
            if (DateTime.Compare(h, ClosingHour) < 0) { num_turnos++; }
            return num_turnos;
        }

        public void ocupaLineas(Days dia,DateTime hora, List<Lane> l)
        {
            int d = indexaDia(dia);
            int h = indexaTurno(hora);
            ArrayList tablaTurnos = (ArrayList)tabla[d];
            ArrayList tablaLanes = (ArrayList)tablaTurnos[h];
            Object [] tablaLanes2 = tablaLanes.ToArray();
            for (int i = 0; i < l.Count(); i++) {
                int x = (int)tablaLanes2.ElementAt(i);
                tablaLanes2.SetValue(++x, i);
            }
        }

    }
}
