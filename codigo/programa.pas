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