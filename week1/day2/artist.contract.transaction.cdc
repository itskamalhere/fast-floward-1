import Artist from 0x03

transaction {

    let printerRef: &Artist.Printer
    let collectionRef: &Artist.Collection

    prepare(account: AuthAccount) {
        account.save(
            <- Artist.createCollection(),
            to: /storage/ArtistPictureCollection
        )
        
        self.collectionRef = account            
            .borrow<&Artist.Collection>(from: /storage/ArtistPictureCollection1)
            ?? panic("Couldn't borrow collection reference")
        self.printerRef = getAccount(0x03)
            .getCapability<&Artist.Printer>(/public/ArtistPicturePrinter)
            .borrow()
            ?? panic("Couldn't borrow printer reference")
    }

    execute {
        let pixels = "*   *   *   *   * *     *"
        let canvas = Artist.Canvas(
            width: self.printerRef.width,
            height: self.printerRef.height,
            pixels
        )    
        let picture <- self.printerRef.print(canvas: canvas)
        if(picture == nil) {
            log("Picture with ".concat(pixels).concat(" already exists!"))
            destroy picture
        } else {
            log("Picture printed!")
            self.collectionRef.deposit(picture: <-picture!)
        }
    }
}
