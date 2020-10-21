//Загрузка кртинок на фотохостинг
function upload(file) {
    if (!file || !file.type.match(/image.*/)) return;
    var fd = new FormData();
    fd.append("image", file);
    var xhr = new XMLHttpRequest();
    xhr.open("POST", "https://api.imageban.ru/v1");
    xhr.onload = function () {
        document.querySelector("#customFile_input").value = JSON.parse(xhr.responseText).data.link;
    }
    xhr.setRequestHeader('Authorization', 'TOKEN CrtD5aHKfZwtcVqjzBPP');
    xhr.send(fd);
}

//Визуализация бегунков и подсчет суммы займа
function periodUpdate(vol) {
    document.querySelector('#period_value').value = vol;
    summValue()
}

function amountUpdate(vol) {
    document.querySelector('#amount_value').value = vol;
    summValue()
}

function percentUpdate(vol) {
    document.querySelector('#percent_value').value = vol;
    summValue()
}

function summValue() {
    let period = Number.parseFloat(document.querySelector('#period_value').value);
    let amount = Number.parseFloat(document.querySelector('#amount_value').value);
    let percent = Number.parseFloat(document.querySelector('#percent_value').value);
    document.querySelector('#summ_value').value = amount + (amount * (((percent / 30) * period) / 100));
}

//Увеличение картинки по клику
$(function () {
    $('.minimized').click(function (event) {
        var i_path = $(this).attr('src');
        $('body').append('<div id="overlay"></div><div id="magnify"><img src="' + i_path + '"><div id="close-popup"><i></i></div></div>');
        $('#magnify').css({
            left: ($(document).width() - $('#magnify').outerWidth()) / 2,
            top: ($(window).height() - $('#magnify').outerHeight()) / 2
        });
        $('#overlay, #magnify').fadeIn('fast');
    });

    $('body').on('click', '#close-popup, #overlay', function (event) {
        event.preventDefault();
        $('#overlay, #magnify').fadeOut('fast', function () {
            $('#close-popup, #magnify, #overlay').remove();
        });
    });
});
