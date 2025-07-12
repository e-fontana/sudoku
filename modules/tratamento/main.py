import main
import start_treatment
import dificulty_treatment

from modelo import Modelo
import start_treatment
import dificulty_treatment
import visibility_treatment

modelo = Modelo()

def treat_enter(process: str, value: str):
    match process:
        case 'start':
            modelo.setStart(start_treatment.def_start(value))
        case 'difficulty':
            modelo.setDificulty(dificulty_treatment.def_dificulty(value))
        case 'map':
            modelo.setMap(value)
        case 'visibility':
            vis, pos, strikes, selNum = visibility_treatment.def_visibility(value)
            modelo.setVisibility(vis, pos, strikes, selNum)
        case 'endgame':
            modelo.setEndgame(value)



