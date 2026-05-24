program SistemaGestionAcademica;

uses crt;

type
    
    DatosCurso = record
        nombreCurso: string[50];
        profesor: string[50];
        nota: real;
        peso: integer; // Créditos de la materia
    end;

    
    DatosAlumno = record
        nombreEstudiante: string[50];
        cursos: array[1..10] of DatosCurso; 
        cantidadCursos: integer;
        promedioPonderado: real;
    end;

    
    RegistroProfesor = record
        nombreProf: string[50];
        sumaNotas: real;
        totalNotas: integer;
        aprobados: integer;
        desaprobados: integer;
        promedioNotas: real;
    end;

var
    
    salon: array[1..100] of DatosAlumno;
    cantidadAlumnos: integer;

{ ============================================================================ }
{      PARTE 1: REGISTRO DE ALUMNOS Y NOTAS                                    }
{ ============================================================================ }

  begin 
    write('¿Cuántos alumnos deseas registrar en total?: ');
    readln(cantidadAlumnos);
    //Iniciamos con un for para obtener los datos segun la cantidad de alumnos
    for i := 1 to cantidadAlumnos do
    begin
        clrscr; //este procedimiento sirve para limpiar la pantalla
        writeln('=============================================');
        writeln('           DATOS DEL ALUMNO #', i);
        writeln('=============================================');
        write('Nombre completo del estudiante: ');
        readln(salon[i].nombreEstudiante);
        
        write('¿Cuántos cursos lleva ', salon[i].nombreEstudiante, '?: ');
        readln(salon[i].cantidadCursos);
        
        for j := 1 to salon[i].cantidadCursos do
        begin
            writeln;
            writeln('-> Curso #', j, ' para ', salon[i].nombreEstudiante, ':');
            write('   Nombre del curso: ');
            readln(salon[i].cursos[j].nombreCurso);
            write('   Nombre del profesor: ');
            readln(salon[i].cursos[j].profesor);
            write('   Nota obtenida (0 - 20): ');
            readln(salon[i].cursos[j].nota);
            write('   Peso/Créditos del curso: ');
            readln(salon[i].cursos[j].peso);
        end;
    end;
    
    writeln;
    writeln('=============================================');
    writeln('¡Todos los alumnos y notas guardados con éxito!');
    writeln('Presione cualquier tecla para regresar al menu...');
    readkey; //procedimiento para que el usuario presione una tecla y regresa al menu
end;

{ ============================================================================ }
{      PARTE 2: RANKINGS Y REPORTES EXTENDIDOS                                 }
{ ============================================================================ }

procedure ReportesYRankings;
var
   i, j, k: integer;
   sumaNotasConPeso, sumaPesos: real;
   temp: DatosAlumno;

   //Para consolidar profesores
   profesores: array[1..100] of RegistroProfesor;
   cantidadProfesores: integer;
   existeProfesor: boolean; 
   nombreProfeActual: string[50];
   notaActual: real;

   //Limites para saber si es tercio o decimo
   limiteDecimo, limiteTercio: integer;
   condición: string[30];

   //Variable para hallar los maximos nota x profes
   maxPromedio: real;
   maxAprobados, maxDesaprobados: integer;
   profMaxPromedio, profMaxAprobados, profMaxDesaprobados: string[50];

begin
    clrscr;
    writeln('======================================================================');
    writeln('                   REPORTES Y RANKINGS ACADEMICOS                     ');
    writeln('======================================================================');
    
    if cantidadAlumnos = 0 then //condicionando la entrada de 0 alumnos para cerrar el programa
    begin
        writeln('Error: No hay alumnos registrados en el sistema.');
        writeln('Primero use la opcion 1 para ingresar datos.');
        writeln('======================================================================');
        writeln('Presione cualquier tecla para regresar...');
        readkey;
        exit;
    end;

    //PASO A: Calcular el Promedio Ponderado de cada alumno
    for i := 1 to cantidadAlumnos do
    begin
        sumaNotasConPeso := 0;
        sumaPesos := 0;
        
        for j := 1 to salon[i].cantidadCursos do
        begin
            sumaNotasConPeso := sumaNotasConPeso + (salon[i].cursos[j].nota * salon[i].cursos[j].peso);
            sumaPesos := sumaPesos + salon[i].cursos[j].peso;
        end;
        
        if sumaPesos > 0 then
            salon[i].promedioPonderado := sumaNotasConPeso / sumaPesos
        else
            salon[i].promedioPonderado := 0;
    end;

    //PASO B: Ordenar alumnos de mayor a menor (usando método burbuja)
    for i := 1 to cantidadAlumnos - 1 do
    begin
        for j := 1 to cantidadAlumnos - i do
        begin
            if salon[j].promedioPonderado < salon[j+1].promedioPonderado then
            begin
                temp := salon[j];
                salon[j] := salon[j+1];
                salon[j+1] := temp;
            end;
        end;
    end;

    //PASO C: Calcular los Decimos y Tercio superior
    for i :=1 to cantidadAlumnos - 1 do
    begin
        for j := 1 to cantidadAlumnos - i do
        begin 
            if salon[j].promedioPonderado  < salon[j+1].promedioPonderado then
            begin
               temp := salon[j];
               salon[j] := salon[j+1];
               salon[j+1] := temp; 
            end;
        end;
    end;

    //PASO D: Calcular topes para decimo y Tercio superior 
    limiteDecimo := cantidadAlumnos div 10;
    if(limiteDecimo = 0) and (cantidadAlumnos >=1) then limiteDecimo := 1;

    limiteTercio := cantidadAlumnos div 3;
    if (limiteTercio = 0) and (cantidadAlumnos >= 1) then limiteTercio := 1;

  //PASO E: Procesar y agrupar datos por Profesor 
    cantidadProfesores := 0;

    for i := 1 to cantidadAlumnos do
    begin
        for j := 1 to salon[i].cantidadCursos do
        begin
            nombreProfActual := salon[i].cursos[j].profesor;
            notaActual := salon[i].cursos[j].nota;
            existeProfesor := false;
            
            for k := 1 to cantidadProfesores do
            begin
                if profesores[k].nombreProf = nombreProfActual then
                begin
                    existeProfesor := true;
                    profesores[k].sumaNotas := profesores[k].sumaNotas + notaActual;
                    profesores[k].totalNotas := profesores[k].totalNotas + 1;
                    
                    if notaActual >= 10.5 then 
                        profesores[k].aprobados := profesores[k].aprobados + 1
                    else
                        profesores[k].desaprobados := profesores[k].desaprobados + 1;
                end;
            end;
            
            if not existeProfesor then
            begin
                cantidadProfesores := cantidadProfesores + 1;
                profesores[cantidadProfesores].nombreProf := nombreProfActual;
                profesores[cantidadProfesores].sumaNotas := notaActual;
                profesores[cantidadProfesores].totalNotas := 1;
                
                if notaActual >= 10.5 then
                begin
                    profesores[cantidadProfesores].aprobados := 1;
                    profesores[cantidadProfesores].desaprobados := 0;
                end
                else
                begin
                    profesores[cantidadProfesores].aprobados := 0;
                    profesores[cantidadProfesores].desaprobados := 1;
                end;
            end;
        end;
    end;
 //calcular el promedio de cada profesor antes de imprimir y comparar
    for i := 1 to cantidadProfesores do
    begin
        if profesores[i].totalNotas > 0 then
            profesores[i].promedioNotas := profesores[i].sumaNotas / profesores[i].totalNotas
        else
            profesores[i].promedioNotas := 0;
    end;


    //PASO F: Mostrar Reporte Analítico por Profesor
    writeln(' RENDIMIENTO ANALITICO POR DOCENTE:');
    writeln('Profesor             | Prom. Nota | Aprobados | Desaprobados');
    writeln('--------------------------------------------------------');
    for i := 1 to cantidadProfesores do
    begin
        writeln(profesores[i].nombreProf:20,' | ', 
                profesores[i].promedioNotas:10:2,' | ', 
                profesores[i].aprobados:9,' | ', 
                profesores[i].desaprobados:12);
    end;
    writeln('=========================================================');
    writeln;

    //PASO G: Evaluar e Imprimir los Máximos por Profesor
    maxPromedio := profesores[1].promedioNotas;
    profMaxPromedio := profesores[1].nombreProf;
    
    maxAprobados := profesores[1].aprobados;
    profMaxAprobados := profesores[1].nombreProf;
    
    maxDesaprobados := profesores[1].desaprobados;
    profMaxDesaprobados := profesores[1].nombreProf;

    //Recorremos los demás profesores para buscar récords
    for i := 2 to cantidadProfesores do
    begin
        if profesores[i].promedioNotas > maxPromedio then
        begin
            maxPromedio := profesores[i].promedioNotas;
            profMaxPromedio := profesores[i].nombreProf;
        end;
        
        if profesores[i].aprobados > maxAprobados then
        begin
            maxAprobados := profesores[i].aprobados;
            profMaxAprobados := profesores[i].nombreProf;
        end;
        
        if profesores[i].desaprobados > maxDesaprobados then
        begin
            maxDesaprobados := profesores[i].desaprobados;
            profMaxDesaprobados := profesores[i].nombreProf;
        end;
    end;
 //Imprimir el cuadro de resumen final de profesores
    writeln(' RESUMEN GENERAL DE DESTACADOS Y ALERTAS DE DOCENTES:');
    writeln('----------------------------------------------------------------------');
    writeln(' -> Mayor Promedio de Notas : ', profMaxPromedio, ' (Prom: ', maxPromedio:2:2, ')');
    writeln(' -> Mayor Cantidad Aprobados: ', profMaxAprobados, ' (Cant: ', maxAprobados, ' alumnos)');
    writeln(' -> Mayor Cantidad Jalaos   : ', profMaxDesaprobados, ' (Cant: ', maxDesaprobados, ' alumnos)');
    writeln('======================================================================');
    
    writeln;
    writeln('Presione cualquier tecla para regresar al menu...');
    readkey;
end;


{ ============================================================================ }
{      PROGRAMA PRINCIPAL (EL MENÚ DE LA APLICACIÓN)                           }
{ ============================================================================ }
var
    opcion: integer;
begin
    cantidadAlumnos := 0; 
    
    repeat //bucle que mostrara el menu mientras no se seleccione la opcion 3 para salir
        clrscr;
        writeln('=============================================');
        writeln('       SISTEMA DE GESTION ACADEMICA          ');
        writeln('=============================================');
        writeln('1. Registrar Alumnos y Notas');
        writeln('2. Mostrar Reportes y Rankings');
        writeln('3. Salir del Sistema');
        writeln('=============================================');
        write('Seleccione una opcion (1-3): ');
        readln(opcion);
        
        case opcion of
            1: RegistrarAlumnos;   
            2: ReportesYRankings;  
            3: writeln('Saliendo del programa... ¡Hasta luego!');
        else
            writeln('Opcion no valida. Intente de nuevo.');
            delay(1500); //El programa se queda frenado un segundo y medio paraleer el aviso de que la opción no es válida y que la pantalla se limpie
        end;
        
    until opcion = 3;
end.