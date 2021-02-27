let counter = 1;

function add(n) {
    counter += n;
    update();
}

function update() {
    if (callback) {
        callback(counter);
    }
}

timer.setInterval(() => {
    counter += 1;
    update();
}, 1);

update();
