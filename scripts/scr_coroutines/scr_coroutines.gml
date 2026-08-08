global.routines = []

//@param {function} check This function will run and check if it return true
//@param {function} callback This function will run when "check" returns true
function call_when_true(check, callback)
{
    array_push(global.routines, { type: 0, check_func: check, call_func: callback })
    return array_length(global.routines) - 1;
}

function update_routines()
{
    for(var i = 0; i < array_length(global.routines); i++)
    {
        switch (global.routines[i].type)
        {
            case 0:
                if (global.routines[i].check_func())
                {
                    global.routines[i].call_func();
                    array_delete(global.routines, i, 1);
                }
        }
    }
}

function stop_coroutine(id)
{
    array_delete(global.routines, id, 1);
}