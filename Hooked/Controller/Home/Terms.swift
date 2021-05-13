//
//  TermsViewController.swift
//  Hooked
//
//  Created by Michael Roundcount on 3/30/21.
//  Copyright © 2021 Michael Roundcount. All rights reserved.
//

import UIKit

protocol termsPopUpDelegate {
    func handleDismissal()
    func proceedToCreateAccount()
    //func navigateToUpload()
    //func navigateToWebsite()
}

class Terms: UIView {
    
    // MARK: - Properties
    var delegate: termsPopUpDelegate?
    


    let acceptBtn: UIButton = {
        let acceptBtn = UIButton(type: .system)
        acceptBtn.backgroundColor = UIColor.mainBlue()
        acceptBtn.setTitle("Accept Terms of Service", for: .normal)
        acceptBtn.setTitleColor(.white, for: .normal)
        acceptBtn.addTarget(self, action: #selector(proceedToCreateAccount), for: .touchUpInside)
        acceptBtn.translatesAutoresizingMaskIntoConstraints = false
        acceptBtn.layer.cornerRadius = 5
        return acceptBtn
    }()
    
    let cancelBtn: UIButton = {
        let cancelBtn = UIButton(type: .system)
        cancelBtn.backgroundColor = UIColor.mainBlue()
        cancelBtn.setTitle("Cancel", for: .normal)
        cancelBtn.setTitleColor(.white, for: .normal)
        cancelBtn.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        cancelBtn.translatesAutoresizingMaskIntoConstraints = false
        cancelBtn.layer.cornerRadius = 5
        return cancelBtn
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(termsTxt)
        termsTxt.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        termsTxt.topAnchor.constraint(equalTo: topAnchor, constant: 25).isActive = true
        termsTxt.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        termsTxt.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        //notificationLabel.numberOfLines = 0
        
        addSubview(acceptBtn)
        acceptBtn.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        acceptBtn.topAnchor.constraint(equalTo: termsTxt.bottomAnchor, constant: 30).isActive = true
        //websiteBtn.topAnchor.constraint(equalTo: AppUploadBtn.bottomAnchor, constant: 10).isActive = true
        acceptBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        acceptBtn.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        acceptBtn.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        
        addSubview(cancelBtn)
        cancelBtn.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        cancelBtn.topAnchor.constraint(equalTo: acceptBtn.bottomAnchor, constant: 10).isActive = true
        //cancelBtn.topAnchor.constraint(equalTo: notificationLabelIII.bottomAnchor, constant: 10).isActive = true
        cancelBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        cancelBtn.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        cancelBtn.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Selectors
    
    @objc func handleDismissal() {
        delegate?.handleDismissal()
    }
    @objc func proceedToCreateAccount() {
        delegate?.proceedToCreateAccount()
    }
    /*
    @objc func navigateToWebsite() {
        delegate?.navigateToWebsite()
    }*/

    
    let termsTxt: UITextView = {
        let textView = UITextView(frame: CGRect(x: 30.0, y: 90.0, width: 250.0, height: 400.0))
        textView.centerXAnchor.constraint(equalTo: textView.centerXAnchor).isActive = true
        //textView.translatesAutoresizingMaskIntoConstraints = false
        textView.contentInsetAdjustmentBehavior = .automatic
        textView.textAlignment = NSTextAlignment.justified
        textView.isScrollEnabled = true
        textView.isEditable = false

        textView.text = """
        END USER LICENSE AGREEMENT
        Last updated April 03, 2021
        Hooked - Playlist Creator is licensed to You (End-User) by Totem LLC, located inMissouri United States (hereinafter: Licensor), for use only under the terms of this License Agreement.
        By downloading the Application from the Apple AppStore, and any update thereto (as permitted by this License Agreement), You indicate that You agree to be bound by all of the terms and conditions of this License Agreement, and that You accept this License Agreement.
        The parties of this License Agreement acknowledge that Apple is not a Party to this License Agreement and is not bound by any provisions or obligations with regard to the Application, such as warranty, liability, maintenance and support thereof. Totem LLC, not Apple, is solely responsible for the licensed Application and the content thereof.
        This License Agreement may not provide for usage rules for the Application that are in conflict with the latest App Store Terms of Service. Totem LLC acknowledges that it had the opportunity to review said terms and this License Agreement is not conflicting with them.
        All rights not expressly granted to You are reserved.
        1. THE APPLICATION
        Hooked - Playlist Creator (hereinafter: Application) is a piece of software created to Allow music artists to share demo and full length audio files with a larger audience - and customized for Apple mobile devices. It is used to Listen to music demo clips and build a playlist..
        The Application is not tailored to comply with industry-specific regulations (Health Insurance Portability and Accountability Act (HIPAA), Federal Information Security Management Act (FISMA), etc.), so if your interactions would be subjected to such laws, you may not use this Application. You may not use the Application in a way that would violate the Gramm-Leach-Bliley Act (GLBA).
        2. SCOPE OF LICENSE
        2.1  You are given a non-transferable, non-exclusive, non-sublicensable license to install and use the Licensed Application on any Apple-branded Products that You (End-User) own or control and as permitted by the Usage Rules set forth in this section and the App Store Terms of Service, with the exception that such licensed Application may be accessed and used by other accounts associated with You (End-User, The Purchaser) via Family Sharing or volume purchasing.
        2.2  This license will also govern any updates of the Application provided by Licensor that replace, repair, and/or supplement the first Application, unless a separate license is provided for such update in which case the terms of that new license will govern.
        2.3  You may not share or make the Application available to third parties (unless to the degree allowed by the Apple Terms and Conditions, and with Totem LLC's prior written consent), sell, rent, lend, lease or otherwise redistribute the Application.
        2.4  You may not reverse engineer, translate, disassemble, integrate, decompile, integrate, remove, modify, combine, create derivative works or updates of, adapt, or attempt to derive the source code of the Application, or any part thereof (except with Totem LLC's prior written consent).
        2.5  You may not copy (excluding when expressly authorized by this license and the Usage Rules) or alter the Application or portions thereof. You may create and store copies only on devices that You own or control for backup keeping under the terms of this license, the App Store Terms of Service, and any other terms and conditions that apply to the device or software used. You may not remove any intellectual property notices. You acknowledge that no unauthorized third parties may gain access to these copies at any time.
        2.6  Violations of the obligations mentioned above, as well as the attempt of such infringement, may be subject to prosecution and damages.
        2.7  Licensor reserves the right to modify the terms and conditions of licensing.
        2.8  Nothing in this license should be interpreted to restrict third-party terms. When using the Application, You must ensure that You comply with applicable third-party terms and conditions.
        3. TECHNICAL REQUIREMENTS
        3.1  Licensor attempts to keep the Application updated so that it complies with modified/new versions of the firmware and new hardware. You are not granted rights to claim such an update.
        3.2  You acknowledge that it is Your responsibility to confirm and determine that the app end-user device on which You intend to use the Application satisfies the technical  specifications mentioned above.
        3.3  Licensor reserves the right to modify the technical specifications as it sees appropriate at any time.
        4. MAINTENANCE AND SUPPORT
        4.1  The Licensor is solely responsible for providing any maintenance and support services for this licensed Application. You can reach the Licensor at the email address listed in the App Store Overview for this licensed Application.
        4.2  Totem LLC and the End-User acknowledge that Apple has no obligation whatsoever to furnish any maintenance and support services with respect to the licensed Application.
        5. USE OF DATA
        You acknowledge that Licensor will be able to access and adjust Your downloaded licensed Application content and Your personal information, and that Licensor's use of such material and information is subject to Your legal agreements with Licensor and Licensor's privacy policy: https://www.termsfeed.com/live/a14829ec-0ebf-4a0a-8d49-af6f3f0534cb.
        6. USER GENERATED CONTRIBUTIONS
        The Application may invite you to chat, contribute to, or participate in blogs, message boards, online forums, and other functionality, and may provide you with the opportunity to create, submit, post, display, transmit, perform, publish, distribute, or broadcast content and materials to us or in the Application, including but not limited to text, writings, video, audio, photographs, graphics, comments, suggestions, or personal information or other material (collectively, "Contributions"). Contributions may be viewable by other users of the Application and through third-party websites or applications. As such, any Contributions you transmit may be treated as non-confidential and non-proprietary. When you create or make available any Contributions, you thereby represent and warrant that:
        1. The creation, distribution, transmission, public display, or performance, and the accessing, downloading, or copying of your Contributions do not and will not infringe the proprietary rights, including but not limited to the copyright, patent, trademark, trade secret, or moral rights of any third party.
        2. You are the creator and owner of or have the necessary licenses, rights, consents, releases, and permissions to use and to authorize us, the Application, and other users of the Application to use your Contributions in any manner contemplated by the Application and these Terms of Use.
        3. You have the written consent, release, and/or permission of each and every identifiable individual person in your Contributions to use the name or likeness or each and every such identifiable individual person to enable inclusion and use of your Contributions in any manner contemplated by the Application and these Terms of Use.
        4. Your Contributions are not false, inaccurate, or misleading.
        5. Your Contributions are not unsolicited or unauthorized advertising, promotional materials, pyramid schemes, chain letters, spam, mass mailings, or other forms of solicitation.
        6. Your Contributions are not obscene, lewd, lascivious, filthy, violent, harassing, libelous, slanderous, or otherwise objectionable (as determined by us).
        7. Your Contributions do not ridicule, mock, disparage, intimidate, or abuse anyone.
        8. Your Contributions are not used to harass or threaten (in the legal sense of those terms) any other person and to promote violence against a specific person or class of people.
        9. Your Contributions do not violate any applicable law, regulation, or rule.
        10. Your Contributions do not violate the privacy or publicity rights of any third party.
        11. Your Contributions do not contain any material that solicits personal information from anyone under the age of 18 or exploits people under the age of 18 in a sexual or violent manner.
        12. Your Contributions do not violate any applicable law concerning child pornography, or otherwise intended to protect the health or well-being of minors.
        13. Your Contributions do not include any offensive comments that are connected to race, national origin, gender, sexual preference, or physical handicap.
        14. Your Contributions do not otherwise violate, or link to material that violates, any provision of these Terms of Use, or any applicable law or regulation.
        Any use of the Application in violation of the foregoing violates these Terms of Use and may result in, among other things, termination or suspension of your rights to use the Application.
        7. CONTRIBUTION LICENSE
        By posting your Contributions to any part of the Application or making Contributions accessible to the Application by linking your account from the Application to any of your social networking accounts, you automatically grant, and you represent and warrant that you have the right to grant, to us an unrestricted, unlimited, irrevocable, perpetual, non-exclusive, transferable, royalty-free, fully-paid, worldwide right, and license to host, use copy, reproduce, disclose, sell, resell, publish, broad cast, retitle, archive, store, cache, publicly display, reformat, translate, transmit, excerpt (in whole or in part), and distribute such Contributions (including, without limitation, your image and voice) for any purpose, commercial advertising, or otherwise, and to prepare derivative works of, or incorporate in other works, such as Contributions, and grant and authorize sublicenses of the foregoing. The use and distribution may occur in any media formats and through any media channels.
        This license will apply to any form, media, or technology now known or hereafter developed, and includes our use of your name, company name, and franchise name, as applicable, and any of the trademarks, service marks, trade names, logos, and personal and commercial images you provide. You waive all moral rights in your Contributions, and you warrant that moral rights have not otherwise been asserted in your Contributions.
        We do not assert any ownership over your Contributions. You retain full ownership of all of your Contributions and any intellectual property rights or other proprietary rights associated with your Contributions. We are not liable for any statements or representations in your Contributions provided by you in any area in the Application. You are solely responsible for your Contributions to the Application and you expressly agree to exonerate us from any and all responsibility and to refrain from any legal action against us regarding your Contributions.
        We have the right, in our sole and absolute discretion, (1) to edit, redact, or otherwise change any Contributions; (2) to re-categorize any Contributions to place them in more appropriate locations in the Application; and (3) to pre-screen or delete any Contributions at any time and for any reason, without notice. We have no obligation to monitor your Contributions.
        8. LIABILITY
        8.1  Licensor's responsibility in the case of violation of obligations and tort shall be limited to intent and gross negligence. Only in case of a breach of essential contractual duties (cardinal obligations), Licensor shall also be liable in case of slight negligence. In any case, liability shall be limited to the foreseeable, contractually typical damages. The limitation mentioned above does not apply to injuries to life, limb, or health.
        8.2  Licensor takes no accountability or responsibility for any damages caused due to a breach of duties according to Section 2 of this Agreement. To avoid data loss, You are required to make use of backup functions of the Application to the extent allowed by applicable third-party terms and conditions of use. You are aware that in case of alterations or manipulations of the Application, You will not have access to licensed Application.
        9. WARRANTY
        9.1  Licensor warrants that the Application is free of spyware, trojan horses, viruses, or any other malware at the time of Your download. Licensor warrants that the Application works as described in the user documentation.
        9.2  No warranty is provided for the Application that is not executable on the device, that has been unauthorizedly modified, handled inappropriately or culpably, combined or installed with inappropriate hardware or software, used with inappropriate accessories, regardless if by Yourself or by third parties, or if there are any other reasons outside of Totem LLC's sphere of influence that affect the executability of the Application.
        9.3  You are required to inspect the Application immediately after installing it and notify Totem LLC about issues discovered without delay by e-mail provided in Product Claims. The defect report will be taken into consideration and further investigated if it has been mailed within a period of __________ days after discovery.
        9.4  If we confirm that the Application is defective, Totem LLC reserves a choice to remedy the situation either by means of solving the defect or substitute delivery.
        9.5  In the event of any failure of the Application to conform to any applicable warranty, You may notify the App-Store-Operator, and Your Application purchase price will be refunded to You. To the maximum extent permitted by applicable law, the App-Store-Operator will have no other warranty obligation whatsoever with respect to the App, and any other losses, claims, damages, liabilities, expenses and costs attributable to any negligence to adhere to any warranty.
        9.6  If the user is an entrepreneur, any claim based on faults expires after a statutory period of limitation amounting to twelve (12) months after the Application was made available to the user. The statutory periods of limitation given by law apply for users who are consumers.
        10. PRODUCT CLAIMS
        Totem LLC and the End-User acknowledge that Totem LLC, and not Apple, is responsible for addressing any claims of the End-User or any third party relating to the licensed Application or the End-User’s possession and/or use of that licensed Application, including, but not limited to:
        (i) product liability claims;
        (ii) any claim that the licensed Application fails to conform to any applicable legal or regulatory requirement; and
        (iii) claims arising under consumer protection, privacy, or similar legislation, including in connection with Your Licensed Application’s use of the HealthKit and HomeKit.
        11. LEGAL COMPLIANCE
        You represent and warrant that You are not located in a country that is subject to a U.S. Government embargo, or that has been designated by the U.S. Government as a "terrorist supporting" country; and that You are not listed on any U.S. Government list of prohibited or restricted parties.
        12. CONTACT INFORMATION
        For general inquiries, complaints, questions or claims concerning the licensed Application, please contact:
        13. TERMINATION
        The license is valid until terminated by Totem LLC or by You. Your rights under this license will terminate automatically and without notice from Totem LLC if You fail to adhere to any term(s) of this license. Upon License termination, You shall stop all use of the Application, and destroy all copies, full or partial, of the Application.
        14. THIRD-PARTY TERMS OF AGREEMENTS AND BENEFICIARY
        Totem LLC represents and warrants that Totem LLC will comply with applicable third-party terms of agreement when using licensed Application.
        In Accordance with Section 9 of the "Instructions for Minimum Terms of Developer's End-User License Agreement," Apple and Apple's subsidiaries shall be third-party beneficiaries of this End User License Agreement and - upon Your acceptance of the terms and conditions of this license agreement, Apple will have the right (and will be deemed to have accepted the right) to enforce this End User License Agreement against You as a third-party beneficiary thereof.
        15. INTELLECTUAL PROPERTY RIGHTS
        Totem LLC and the End-User acknowledge that, in the event of any third-party claim that the licensed Application or the End-User's possession and use of that licensed Application infringes on the third party's intellectual property rights, Totem LLC, and not Apple, will be solely responsible for the investigation, defense, settlement and discharge or any such intellectual property infringement claims.
        16. APPLICABLE LAW
        This license agreement is governed by the laws of the State of Missouri excluding its conflicts of law rules.
        17. MISCELLANEOUS
        17.1  If any of the terms of this agreement should be or become invalid, the validity of the remaining provisions shall not be affected. Invalid terms will be replaced by valid ones formulated in a way that will achieve the primary purpose.
        17.2  Collateral agreements, changes and amendments are only valid if laid down in writing. The preceding clause can only be waived in writing.
"""

        return textView
    }()
    
    
}

