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