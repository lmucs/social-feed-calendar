expect = require('chai').expect
request = require 'request'

serverName = 'http://localhost:3000/'
twitterURL = 'twitter/posts/'
fbPostURL = 'facebook/posts/'

twitterScreenNames = [
  'ACTILMU'
  'LMULionTRaXC'
  'IggyLion'
  'Lmulionspolo'
  'lmuhoops'
  'golflmu'
  'lmumsoc'
  'LMUMTennis'
  'RowingLMU'
  'lmusoftball'
  'LMUStrength'
  'lmuwbb'
  'LMUSWIM'
  'lmu_volleyball'
  'LMULions'
  'burnreccenter'
  'lmu_ministry'
  'csa_lmu'
  'lmucsla'
  'CURes_LMU'
  'LMU_CBA'
  'LMUHospitality'
  'lmueis'
  'lmuexecutivemba'
  'LMUFacSen'
  'lmu_fos'
  'LMUFinancialaid'
  'lmugraduate'
  'lmugreeklife'
  'lmulibrary'
  'LMU_History'
  'lmucares'
  'lmuexp'
  'LALoyolan'
  'LoyolaLawSchool'
  'LoyolaMarymount'
  'MEforLMU'
  'LMUMARCOMM'
  'lmumbaprogram'
  'lmunewsroom'
  'LMUCareers'
  'LMU_OISS'
  'LMUPlaceCorps'
  'roarstudios'
  'lmusoe'
  'LMUDoctoral'
  'LMUsftv'
  'seaverlmu'
  'lmuhousing'
  'studyabroadlmu'
  'LMUTFALA'
  'LMUTFANorCal'
  'LMUTower'
  'tsehai'
  'LMUAdmission'
]

fbScreenNames = [
  "actilmu"
  "groups/lmuaaaa"
  "lmualumni"
  "lmustararhs"
  "aspalmu"
  "LMUWomensVolleyball"
  "LMULionTRaXC"
  "lmumensbasketball"
  "GolfLMU"
  "LMUMTennis"
  "LMURowing"
  "LoyolaMarymountUniversitySoftball"
  "LMUSwimming"
  "LMUWomensBasketball"
  "LMUWomensSoccer"
  "LMUWomensTennis"
  "LmuWomensWaterPolo"
  "LMULions"
  "BiologyLMU"
  "LmuBurnsRecreationCenter"
  "lmucampusmin"
  "LMUCAST"
  "groups/39893463773"
  "lmucrs"
  "LMUCSA"
  "LMUCSLA"
  "lmucures"
  "lmucba"
  "lmucommunityrelations"
  "LMUCS"
  "LMUConferences"
  "LMUdanceprogram"
  "lmuhospitality"
  "LMU-English-Department-280903465269783"
  "LMUEIS"
  "LMUEMBA"
  "LMUExtension"
  "LMUFacultySenate"
  "lmufos"
  "LMUGradAdmission"
  "lmugreeklife"
  "lmulibrary"
  "LMUHistoryDepartment"
  "leadershiplmu"
  "LMUInternationalOutreach"
  "irishstudieslmu"
  "KXLU889"
  "Laband-Art-Gallery-255909641096056"
  "LmuLatinoAlumniAssociation"
  "lmulionparents"
  "lmucares"
  "lmusoe"
  "LosAngelesLoyolan"
  "LoyolaLawSchool"
  "LLSAlumniNetwork"
  "lmula"
  "LMU-M-School-497182070316821"
  "ManeEntertainmentLMU"
  "Marymount-Institute-Press-180302548725093"
  "LMUMBAProgram"
  "lmucareers"
  "oisslmu"
  "lmupols"
  "lmuschoolpsychology"
  "roarstudiosla"
  "LMUDoctoral"
  "LMUSFTV"
  "LMUCenterforStudentSuccess"
  "lmuseaver"
  "LMUStudentHousing"
  "LMUTFANorCal"
  "tsehaipublishers"
  "lmuadmission"
  "lmuyoga"
  "lmuyogastudies"
]

describe 'Making social media requests', ->
  describe 'when making Twitter API calls', ->
    for name in twitterScreenNames
      do(name) ->
        it "We get a 200 from #{name}", (done) ->
          console.log "We are making a request for #{name}"
          requestURL = "#{serverName}#{twitterURL}#{name}"
          request requestURL, (err, res, body) ->
            expect(res.statusCode).to.eql 200
            done()

  describe 'when making Facebook API calls', ->
    for name in fbScreenNames
      do(name) ->
        it "We get a 200 from #{name}", (done) ->
          requestURL = "#{serverName}#{fbPostURL}#{name}"
          request requestURL, (err, res, body) ->
            expect(res.statusCode).to.eql 200
            expect((JSON.parse body).data).to.not.eql undefined
            done()