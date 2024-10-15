class Csrf {

    getToken() {
        const name = 'csrftoken'; // Tên cookie CSRF
        const value = `; ${document.cookie}`;
        const parts = value.split(`; ${name}=`);
        if (parts.length === 2) return parts.pop().split(';').shift();
        return null;
    }
}

export default new Csrf();
