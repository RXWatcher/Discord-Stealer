let ERROR = 'ASCII_ERROR=Unknown Characters found'

function isValid(str){
    if(typeof(str)!=='string'){
        console.log(ERROR);
        process.exit(0)
    }
    for(var i=0;i<str.length;i++){
        if(str.charCodeAt(i)>127){
            console.log(ERROR);
            process.exit(0)
        }
    }
}

isValid(process.argv[2])