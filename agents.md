#  MACE ROULETTE - Protocol de Operare (v2.0)

## 1.  Arhitectură și Flux de Lucru (Rojo/VS Code)
* **Workflow:** Proiect sincronizat via Rojo (`rojo serve`). Sursa se află în `src/`.
* **Comandă Build:** `rojo build -o "HAMMER ROULETTE.rbxlx"`.
* **Sistem Modular:** Server în `src/server/modules`, Client în `src/client`, Shared în `src/shared`.
* **RemoteEvents:** Instanțiere OBLIGATORIE la startup în `MainGameLoop.server.luau`. Interzisă crearea lor mid-game pentru a preveni timeout-urile și erorile de tip "missing child" pe client.
* **Deep Planning Mode:** Agentul TREBUIE să pună întrebări de clarificare și să confirme planul de execuție prin `set_plan` înainte de a genera orice cod.

## 2.  Mecanici de Luptă: Mace Loop
* **Ciclul Principal:** Player cu Mace -> Jump Boost -> Airborne State -> Validare Atac -> Bounce (la hit) sau Reset (la aterizare).
* **Detecție Aterizare (STRICT):** NU folosi timere sau grace periods. Verifică strict `AssemblyLinearVelocity.Y <= 0` înainte de a rula logica de coliziune cu solul pentru a confirma că playerul chiar cade.
* **Bounce System:** Lovirea unui inamic în aer oferă un impuls vertical (Bounce) pentru a continua streak-ul fără a atinge solul.
* **Vertical Hit Check:** Validare obligatorie pe axa Y: `attacker.Position.Y > victim.Position.Y + 2.5` pentru a garanta loviturile de deasupra.
* **Resetarea Rundei:** Atingerea solului = Pierderea Mace-ului + dezactivare abilități + `ModifierManager.ClearRoundModifiers()`.
* **Meci vs Rundă:** Harta se spawnează o dată pe meci (outer loop). Teleportarea și resetarea statusurilor se fac la fiecare rundă (inner loop).

## 3.  Fizică, Mișcare și Securitate (R6)
* **Momentum Reset:** La orice teleportare (Matchmaking/Spawn), resetează `AssemblyLinearVelocity` și `AssemblyAngularVelocity` la `0,0,0` și forțează starea `Enum.HumanoidStateType.Landed`.
* **Scalare Gravitațională:** Impulsurile de jump/bounce se scalează automat în funcție de `Workspace.Gravity` pentru a preveni ieșirea din mapă în medii cu gravitație scăzută.
* **Bunnyhop Prevention:** Dezactivează starea `Jumping` imediat ce playerul este airborne; reactivare doar după aterizarea completă și stabilizarea fizicii.
* **Validare Input:** Orice Vector3 de la client trebuie verificat pe server: tip `Vector3`, check anti-NaN (`v == v`) și Magnitude check față de poziția jucătorului.
* **Spawn Fix:** Folosește un downward raycast din punctul de spawn pentru a găsi podeaua reală, evitând micro-căderile care pot declanșa eronat landing logic.

## 4.  Managementul Stărilor (ModifierManager)
* **Persistență:** Modificările (Viteză, Friction, Scale) se înregistrează centralizat pentru a fi reaplicate automat după respawn în `ModifierManager.ReapplyPlayerStates`.
* **Grupuri de Excludere:** Modificatorii din același grup (ex: doi modificatori de viteză) se suprascriu reciproc, nu se cumulează.
* **Regulă Health:** Regenerarea naturală este dezactivată permanent (`Health.Disabled = true`).
* **Scale Reset:** Valorile de BodyScale (Height, Width, Depth, Head) se resetează forțat la 1 între runde pentru a preveni creșterea infinită.

## 5.  VFX și Randare Vizuală
* **Ghost Transparency:** Pentru Highlights vizibile pe caractere "invizibile", folosește transparență `0.99`. Highlights nu se randează pe părți cu transparență `1.0`.
* **Client-Side Primacy:** Modificările vizuale globale (Fog of War, Outlines) se aplică DOAR pe client pentru a proteja setările Lighting de pe server.
* **Cylinder Orientation:** Orice shockwave cilindric se rotește 90 de grade pe axa Z: `CFrame.Angles(0, 0, math.rad(90))`.
* **Memory Safety:** Folosește tabele cu Weak Keys (`setmetatable({}, {__mode = 'k'})`) pentru cache-ul de date ale caracterelor (VFX Colors) pentru a permite Garbage Collection.

## 6.  Standarde UI (User Interface)
* **Prevenire Flash:** La pornire, UI-ul trebuie ascuns instant (`Visible = false`, `Size = UDim2.new(0,0,0,0)`) înainte de orice yield.
* **OriginalSize:** Salvează dimensiunile originale în atribute (`OriginalSizeXScale`) înainte de a ascunde elementele pentru a permite tweens corecte ulterior.
* **Gestiune Text:** Pentru liste infinite: `TextScaled = false`, `TextWrapped = true` și `AutomaticSize = Enum.AutomaticSize.Y`.
* **Naming:** Butoanele folosesc sufixul `BUTTMAIN` pentru a evita selectarea greșită în scripturi când există Frame-uri cu același nume.

## 7.  Reguli de Codare (Luau)
* **Fără WaitForChild:** Interzis la nivel de root scope în ModuleScripts. Se folosește doar în funcții de inițializare (ex: `Start()`).
* **Reparenting:** NU folosi `while #folder:GetChildren() > 0`. Folosește mereu `for _, child in ipairs(folder:GetChildren()) do`.
* **Debug Messages:** Limba Română, format obligatoriu: `print("[DEBUG] NumeSistem: Mesaj")`.
* **Tool Stealth:** Pentru unelte fără animația de braț ridicat: `RequiresHandle = false`, redenumire `Handle` și transparență `1`.