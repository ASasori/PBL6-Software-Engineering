class Auth{
    constructor(){
        this.tokenKey = 'authToken';
    }

    saveToken(token){
        localStorage.setItem(this.tokenKey, token);
    }

    getToken(){
        return localStorage.getItem(this.tokenKey);
    }

    removeToken(){
        localStorage.removeItem(this.tokenKey);
    }

    isAuthenticated(){
        return this.getToken() !== null;
    }
}

export default new Auth();