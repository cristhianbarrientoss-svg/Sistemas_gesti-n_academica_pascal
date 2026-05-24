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


