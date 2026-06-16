let userLife = 3;
let botLife = 3;

/* HEART RENDERING */

function renderHearts(){
    let userHearts="";
    let botHearts="";

    for(let i=0; i<userLife; i++){
        userHearts += '<img src="heart.png" class="heart">';
    }

    for(let i=0; i<botLife; i++){
        botHearts += '<img src="heart.png" class="heart">';
    }

    document.getElementById("userLives").innerHTML = userHearts;
    document.getElementById("botLives").innerHTML = botHearts;

}

renderHearts();

/* MAIN GAME FUNCTION */

function delay(){
    document.getElementById("output").innerHTML = 
    "caculating..."

    setTimeout(calculation,1500);
}

function calculation(){

    let userNum =
        Number(document.getElementById("numValue").value);

    let botNum =
        Math.floor(Math.random() * 101);

    let average =
        (userNum + botNum) / 2;

    let spiderNum =
        0.8 * average;

    let userDis =
        Math.abs(spiderNum - userNum);

    let botDis =
        Math.abs(spiderNum - botNum);

    if(userNum>100 || userNum<0){
        document.getElementById("output").innerHTML = "Please enter a number between 0 and 100!"
        return
    }

    document.getElementById("output").innerHTML =

        "you entered " + userNum +

        "<br>bot entered " + botNum +

        "<br>average : " + average.toFixed(2) +

        "<br>spider number : " + spiderNum.toFixed(2);

    /* BOT WINS */

    if(userDis > botDis){

        document.getElementById("output").innerHTML +=
            "<br><br>bot won this round";

        userLife -= 1;

        renderHearts();

        if(userLife == 0){

            document.getElementById("output").innerHTML +=
                "<br><br>YOU LOST";

            setTimeout(resetGame,2000);

            return;
        }
    }

    /* TIE */

    else if(userDis == botDis){

        document.getElementById("output").innerHTML +=
            "<br><br>round tied";
    }

    /* USER WINS */

    else{

        document.getElementById("output").innerHTML +=
            "<br>you won this round";

        if(botLife>0){
            botLife -= 1;
        }

        renderHearts();

        if(botLife == 0){

            document.getElementById("output").innerHTML +=
                "<br>YOU WON";

            setTimeout(resetGame,2000);

            return;
        }
    }
}

/* RESET GAME */

function resetGame(){

    userLife = 3;
    botLife = 3;

    renderHearts();

    document.getElementById("output").innerHTML =
        "game restarted";
}

