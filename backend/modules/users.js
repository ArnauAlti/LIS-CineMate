const users_ValidateMail = (mail) => {
    const domains = ["yahoo", "hotmail", "gmail"]
    let str = String(mail)
    let domain = str.split("@")[1]
    domain = str.split(".")[0]
    console.log(domain)
    for (let index = 0; index < domains.length; index++) {
        const element = domains[index]
        if (domain.match(element)) {
            console.log("True")
            return true;
        }
    }
    console.log("False")
    return false;
}

module.exports = users_ValidateMail;