program SistemaGestionAcademica;

uses crt;

type 

    DatosCurso= record
    nombreCurso: string[50];
    profesor: string[50];
    nota: real;
    peso: integer;
end;

DatosAlumno= record
    nombreEstudiante: string[50];
    cursos: array[1..10] of DatosCurso;
    cantidadCursos: integer;
    promedioPonderado: real;
end;

var 
    salon: array[1..100] of DatosAlumno;
    cantidadAlumnos: integer;



procedure RegistrarAlumnos;
begin
    clrscr;
    writeln('========================================');
    writeln('      REGISTRO DE ESTUDIANTES           ');
    writeln('========================================');

    writeln('Espacio reservado para tu codigo de lectura...');

    writeln;
    writeln('Presione cualquier tecla para continuar...');
    readkey;

end;