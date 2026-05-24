program SistemaGestionAcademica;

uses crt;

type 

    DatosCurso= record
    nombreCurso: string[50];
    profesor: string[50];
    nota: real;
    peso: integer;
end;