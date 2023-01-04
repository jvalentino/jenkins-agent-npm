// testing
const expect = require("chai").expect;
const sinon = require('sinon');
const subject = require("../src/index");

// mocks
const fs = require("fs");
let fsMock = null;

describe("index.js", function() {
  
    beforeEach(() => {
        fsMock = sinon.mock(fs);
    });
  
    afterEach(() => {
        sinon.restore();   
        fsMock.restore();
    });

    it("test hello", function() {
        // given
        const name = "John";

        // and: fs.writeFileSync(`hello.txt`, message);
        fsMock.expects("writeFileSync").once()
            .withExactArgs("hello.txt", "Hi John!");

        // when
        const result = subject.hello(name);

        // then
        fsMock.verify();

        expect(result).equals("Hi John!");
    });

});